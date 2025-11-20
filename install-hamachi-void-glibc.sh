#!/bin/bash

echo "==== Instalador automático do Hamachi para Void Linux (glibc) ===="

# Verifica root
if [ "$EUID" -ne 0 ]; then
    echo "Execute como root: sudo $0"
    exit 1
fi

### 1. Verifica se é glibc ###
if ! ldd --version 2>/dev/null | grep -qi "glibc"; then
    echo "ERRO: Este script é apenas para Void Linux GLIBC!"
    exit 1
fi

### 2. Instalar dependências ###
echo "[1/6] Instalando dependências..."
xbps-install -Sy wget ar xz gzip openrc

### 3. Baixar Hamachi ###
echo "[2/6] Baixando LogMeIn Hamachi..."
cd /tmp
wget -O hamachi.deb "https://www.vpn.net/installers/logmein-hamachi_2.1.0.203-1_amd64.deb"

if [ ! -f hamachi.deb ]; then
    echo "ERRO: Falha ao baixar o Hamachi!"
    exit 1
fi

### 4. Extrair o .deb ###
echo "[3/6] Extraindo pacotes do .deb..."
mkdir -p hamachi-extract
cd hamachi-extract

ar x ../hamachi.deb
tar -xvf data.tar.xz

### 5. Instalar binários ###
echo "[4/6] Instalando em /opt/logmein-hamachi..."
mkdir -p /opt/logmein-hamachi
cp -r opt/logmein-hamachi/* /opt/logmein-hamachi/

### 6. Criar links simbólicos ###
echo "[5/6] Criando links simbólicos..."
ln -sf /opt/logmein-hamachi/bin/hamachi /usr/bin/hamachi

### 7. Criar serviço OpenRC ###
echo "[6/6] Criando serviço OpenRC..."

cat > /etc/init.d/hamachid << 'EOF'
#!/sbin/openrc-run

command="/opt/logmein-hamachi/bin/hamachid"
command_args="--daemon"
pidfile="/var/run/hamachid.pid"
depend() {
    need net
}
EOF

chmod +x /etc/init.d/hamachid

rc-update add hamachid default
rc-service hamachid start

echo "==== Hamachi instalado com sucesso! ===="
echo "Primeiro login:"
echo "    sudo hamachi login"
echo "Entrar em rede:"
echo "    sudo hamachi join NOMEDAREDE SENHA"
echo "Ver status:"
echo "    hamachi"
