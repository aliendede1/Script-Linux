#!/usr/bin/env bash
# =======================================================
# UNIVERSAL GAMING INSTALLER SCRIPT (via Flatpak)
# Funciona em Debian, Ubuntu, Mint, Fedora, Arch, Void, openSUSE, etc
# =======================================================

set -e

DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
echo "=============================="
echo " Detectando distribuição: $DISTRO"
echo "=============================="

# ---- Funções por distro ----
install_flatpak() {
    echo "📦 Verificando Flatpak..."
    if ! command -v flatpak &>/dev/null; then
        case "$DISTRO" in
            debian|ubuntu|linuxmint|zorin|pop)
                sudo apt update -y && sudo apt install -y flatpak gnome-software-plugin-flatpak ;;
            fedora)
                sudo dnf install -y flatpak ;;
            arch|manjaro|endeavouros|arco)
                sudo pacman -S --noconfirm flatpak ;;
            void)
                sudo xbps-install -Sy flatpak ;;
            opensuse*)
                sudo zypper install -y flatpak ;;
            *)
                echo "⚠️ Distro não reconhecida. Tentando instalação genérica..."
                sudo apt install -y flatpak || sudo dnf install -y flatpak || sudo pacman -S --noconfirm flatpak || true
                ;;
        esac
    fi
    echo "✅ Flatpak pronto!"
}

# ---- Instalar jogos ----
install_games() {
    echo "🌐 Adicionando repositório Flathub..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "🎮 Instalando plataformas e jogos..."
    flatpak install -y flathub \
        com.valvesoftware.Steam \
        com.heroicgameslauncher.hgl \
        net.lutris.Lutris \
        io.itch.itch \
        org.libretro.RetroArch \
        com.usebottles.bottles \
        net.davidotek.pupgui2 \
        org.freedesktop.Platform.VulkanLayer.MangoHud

    echo "✅ Jogos e plataformas instalados com sucesso!"
}

# ---- Execução principal ----
install_flatpak
install_games

echo "=============================="
echo "🎉 Instalação finalizada!"
echo "Reinicie ou deslogue para integrar os ícones no menu."
echo "=============================="

