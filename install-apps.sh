#!/usr/bin/env bash
# =============================================
# UNIVERSAL INSTALLER SCRIPT (sem Snap)
# Para Debian, Ubuntu, Mint, Arch, Fedora, Void, e outros
# =============================================

set -e

# Detectar distro
DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')

echo "=============================="
echo " Detectando distribuição: $DISTRO"
echo "=============================="

# Funções de instalação
install_debian_like() {
    sudo apt update -y
    sudo apt install -y wget curl git flatpak gnome-software-plugin-flatpak \
        wine64 winetricks lutris \
        kdenlive shotcut gimp audacity obs-studio vlc \

    # Adicionar Flathub
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "✅ Aplicativos instalados no sistema baseado em Debian."
}

install_fedora_like() {
    sudo dnf update -y
    sudo dnf install -y wget curl git flatpak wine winetricks lutris \
        kdenlive shotcut gimp audacity obs-studio vlc \
        telegram-desktop discord zoom

    # Adicionar Flathub
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "✅ Aplicativos instalados no Fedora."
}

install_arch_like() {
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm wget curl git flatpak wine winetricks lutris \
        kdenlive shotcut gimp audacity obs-studio vlc telegram-desktop discord

    # Zoom pelo Flatpak
    flatpak install -y flathub us.zoom.Zoom

    echo "✅ Aplicativos instalados no Arch/Manjaro/EndeavourOS."
}

install_void_like() {
    sudo xbps-install -Suy
    sudo xbps-install -y wget curl git flatpak wine winetricks lutris \
        kdenlive shotcut gimp audacity obs vlc telegram-desktop discord

    # Zoom pelo Flatpak
    flatpak install -y flathub us.zoom.Zoom
    echo "✅ Aplicativos instalados no Void Linux."
}

install_opensuse_like() {
    sudo zypper refresh
    sudo zypper install -y wget curl git flatpak wine winetricks lutris \
        kdenlive shotcut gimp audacity obs-studio vlc telegram-desktop discord

    flatpak install -y flathub us.zoom.Zoom
    echo "✅ Aplicativos instalados no openSUSE."
}

# Instalação conforme distro
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
        echo "⚠️ Distro não reconhecida. Tentando instalação genérica via Flatpak..."
        sudo apt install -y flatpak || sudo dnf install -y flatpak || sudo pacman -S --noconfirm flatpak || true
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub org.kde.kdenlive org.shotcut.Shotcut org.gimp.GIMP org.audacityteam.Audacity com.obsproject.Studio org.telegram.desktop com.discordapp.Discord us.zoom.Zoom
        echo "✅ Instalação Flatpak concluída."
        ;;
esac

echo "=============================="
echo "🎉 Instalação finalizada sem Snap!"
echo "=============================="
