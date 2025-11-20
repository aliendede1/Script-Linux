#!/usr/bin/env bash

set -e

echo "==========================================="
echo "     Instalador Hamachi para Void Linux     "
echo "==========================================="

# Verifica dependências
if ! command -v wget >/dev/null; then
    echo "Instalando wget..."
    sudo xbps-install -y wget
fi

echo "[1] Baixando Hamachi Linux..."
wget -O hamachi.tar.gz https://www.vpn.net/installers/logmein-hamachi_2.1.0.203-1_amd64.tar.gz

echo "[2] Extraindo..."
tar -xvf hamachi.tar.gz
cd logmein-hamachi-2.1.0.203

echo "[3] Instalando..."
sudo make install

echo "[4] Criando serviço Runit..."
sudo mkdir -p /etc/sv/hamachi

sudo tee /etc/sv/hamachi/run >/dev/null << 'EOF'
#!/bin/sh
exec /opt/logmein-hamachi/bin/hamachid
EOF

sudo chmod +x /etc/sv/hamachi/run

echo "[5] Ativando serviço..."
sudo ln -sf /etc/sv/hamachi /var/service/

echo "[6] Inicializando Hamachi..."
sudo hamachi login || true
sudo hamachi agree || true

echo "==========================================="
echo " Hamachi instalado e rodando em background!"
echo "==========================================="

echo ""
read -p "Deseja conectar sua conta Hamachi agora? (s/n): " resp
if [ "$resp" = "s" ]; then
    read -p "Digite seu email da LogMeIn/Hamachi: " email
    sudo hamachi attach "$email"
fi

echo ""
read -p "Deseja entrar em uma rede Hamachi? (s/n): " resp2
if [ "$resp2" = "s" ]; then
    read -p "Nome da rede: " network
    read -p "Senha da rede: " password
    sudo hamachi join "$network" "$password"
fi

echo ""
echo "==========================================="
echo "      Instalação finalizada com sucesso!    "
echo "Use:  hamachi"
echo "==========================================="
