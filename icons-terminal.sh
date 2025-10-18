#!/usr/bin/env bash

set -e

echo "🔍 Detectando distribuição..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    distro=$ID
else
    echo "❌ Não foi possível detectar a distro."
    exit 1
fi

echo "📦 Instalando pacotes necessários para: $distro"

install_pkg() {
    case "$distro" in
        debian|ubuntu|kali|raspbian)
            sudo apt update
            sudo apt install -y fonts-noto-color-emoji fonts-symbola fonts-powerline fonts-firacode fonts-noto
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -Syu --noconfirm noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code ttf-symbola
            ;;
        fedora)
            sudo dnf install -y google-noto-emoji-fonts fira-code-fonts dejavu-sans-fonts
            ;;
        void)
            sudo xbps-install -Sy noto-fonts-emoji dejavu-fonts-ttf font-fira-code
            ;;
        opensuse*|suse)
            sudo zypper install -y noto-coloremoji-fonts fira-code-fonts dejavu-fonts
            ;;
        alpine)
            sudo apk add --no-cache font-noto font-noto-emoji font-dejavu
            ;;
        *)
            echo "⚠️ Distro não reconhecida automaticamente. Tentando pacotes genéricos..."
            ;;
    esac
}

install_pkg

# Diretório local de fontes customizadas (para fallback universal)
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "⬇️ Baixando fontes extras (FiraCode, Nerd Fonts, Symbols)..."
cd "$FONT_DIR"

# FiraCode Nerd Font (símbolos extras)
if [ ! -d "FiraCode" ]; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip -O FiraCode.zip
    unzip -q FiraCode.zip -d FiraCode
    rm FiraCode.zip
fi

# Atualiza cache de fontes
echo "🔄 Atualizando cache de fontes..."
fc-cache -fv > /dev/null

echo "✅ Instalação concluída!"
echo "Agora você tem emojis, ícones e símbolos no terminal 🎉"
