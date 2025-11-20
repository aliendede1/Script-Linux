#!/bin/bash

echo "==============================================="
echo "  COMPILAÇÃO UNIVERSAL DO ZEROTIER (ALL DISTROS)"
echo "==============================================="

# Verifica root
if [ "$EUID" -ne 0 ]; then
    echo "Execute como root: sudo $0"
    exit 1
fi

# Detecta qual gerenciador de pacotes instalar dependências
if command -v xbps-install >/dev/null; then
    PKG="void"
elif command -v apt >/dev/null; then
    PKG="debian"
elif command -v pacman >/dev/null; then
    PKG="arch"
elif command -v dnf >/dev/null; then
    PKG="fedora"
elif command -v zypper >/dev/null; then
    PKG="opensuse"
elif command -v apk >/dev/null; then
    PKG="alpine"
else
    PKG="unknown"
fi

echo "Gerenciador detectado: $PKG"
echo "Instalando dependências de compilação..."

case $PKG in
    void)
        xbps-install -Sy base-devel cmake make gcc g++ git libminiupnpc-devel
    ;;
    debian)
        apt update
        apt install -y build-essential cmake make gcc g++ git libminiupnpc-dev
    ;;
    arch)
        pacman -Sy --noconfirm base-devel cmake git miniupnpc
    ;;
    fedora)
        dnf install -y cmake make gcc gcc-c++ git miniupnpc-devel
    ;;
    opensuse)
        zypper install -y cmake make gcc gcc-c++ git libminiupnpc-devel
    ;;
    alpine)
        apk add build-base cmake git miniupnpc-dev
    ;;
    *)
        echo "Distro desconhecida — tentando dependências genéricas (gcc, cmake, make, git)"
        ;;
esac

echo
echo "=== Baixando o código-fonte do ZeroTier ==="
cd /tmp
rm -rf ZeroTierOne
git clone https://github.com/zerotier/ZeroTierOne.git
cd ZeroTierOne

echo
echo "=== Compilando ZeroTier ==="
make

echo
echo "=== Instalando ZeroTier ==="
make install

# Cria service se o sistema usar systemd
if command -v systemctl >/dev/null; then
    echo "=== Ativando serviço systemd ==="
    if [ -f /usr/local/bin/zerotier-one ]; then
        mkdir -p /etc/systemd/system
        cat > /etc/systemd/system/zerotier-one.service <<EOF
[Unit]
Description=ZeroTier One
After=network.target

[Service]
ExecStart=/usr/local/sbin/zerotier-one -d
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    fi
    systemctl daemon-reload
    systemctl enable --now zerotier-one
fi

# OpenRC (Void, Alpine, Gentoo)
if command -v rc-service >/dev/null; then
    echo "=== Criando serviço OpenRC ==="
    cat > /etc/init.d/zerotier-one <<'EOF'
#!/sbin/openrc-run
description="ZeroTier VPN"
command="/usr/local/sbin/zerotier-one"
command_args="-d"
pidfile="/var/run/zerotier-one.pid"
EOF
    chmod +x /etc/init.d/zerotier-one
    rc-update add zerotier-one default
    rc-service zerotier-one start
fi

# Runit (Void Linux)
if [ -d /etc/runit ] || [ -d /etc/sv ]; then
    echo "=== Criando serviço runit ==="
    mkdir -p /etc/sv/zerotier-one
    cat > /etc/sv/zerotier-one/run <<EOF
#!/bin/sh
exec /usr/local/sbin/zerotier-one -d
EOF
    chmod +x /etc/sv/zerotier-one/run
    ln -sf /etc/sv/zerotier-one /var/service/
fi

echo
echo "===================================="
echo " ZeroTier compilado e instalado! "
echo " Para entrar em uma rede:"
echo "    sudo zerotier-cli join <ID>"
echo "===================================="
