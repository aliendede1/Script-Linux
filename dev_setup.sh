#!/usr/bin/env bash

set -e

DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
echo "=============================="
echo " Detectando distribuição: $DISTRO"
echo "=============================="

install_debian_like() {
    sudo apt update -y
    sudo apt install -y curl wget git build-essential software-properties-common \
        vim neovim python3 python3-pip nodejs npm openjdk-17-jdk \
        gcc g++ clang rustc cargo golang php default-mysql-client sqlite3 \
        lua5.4 unzip ripgrep fd-find

    # Instalar VS Code
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update && sudo apt install -y code

    echo "✅ Debian-like: dependências instaladas."
}

install_fedora_like() {
    sudo dnf update -y
    sudo dnf install -y curl wget git vim neovim python3 python3-pip nodejs npm \
        java-17-openjdk gcc-c++ clang rust cargo go php sqlite \
        ripgrep fd-find unzip

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf install -y code

    echo "✅ Fedora: dependências instaladas."
}

install_arch_like() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm curl wget git vim neovim python python-pip nodejs npm jdk-openjdk \
        gcc clang rust go php sqlite ripgrep fd unzip

    sudo pacman -S --noconfirm code
    echo "✅ Arch/Manjaro: dependências instaladas."
}

install_void_like() {
    sudo xbps-install -Suy
    sudo xbps-install -y curl wget git vim neovim python3 python3-pip nodejs npm openjdk17 \
        gcc clang rust cargo go php sqlite ripgrep fd unzip

    # VS Code Flatpak
    flatpak install -y flathub com.visualstudio.code
    echo "✅ Void Linux: dependências instaladas."
}

install_opensuse_like() {
    sudo zypper refresh
    sudo zypper install -y curl wget git vim neovim python3 python3-pip nodejs npm java-17-openjdk-devel \
        gcc-c++ clang rust cargo go php sqlite3 ripgrep fd unzip

    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
    sudo zypper install -y code

    echo "✅ openSUSE: dependências instaladas."
}

case "$DISTRO" in
    debian|ubuntu|linuxmint|zorin|pop)
        install_debian_like ;;
    fedora)
        install_fedora_like ;;
    arch|manjaro|endeavouros|arco)
        install_arch_like ;;
    void)
        install_void_like ;;
    opensuse*)
        install_opensuse_like ;;
    *)
        echo "⚠️ Distro desconhecida. Instale manualmente dependências básicas."
        ;;
esac


echo "=============================="
echo "🎉 AMBIENTE DE DESENVOLVIMENTO COMPLETO INSTALADO!"
echo "=============================="

