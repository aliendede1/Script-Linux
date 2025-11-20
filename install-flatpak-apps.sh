#!/usr/bin/env bash
# ====================================================================
# Instalador Universal — Produtividade (com categorias + multi seleção)
# Apps via Flatpak — Sem jogos
# ====================================================================

set -e

DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')

install_flatpak() {
    echo "[+] Instalando Flatpak…"

    case $DISTRO in
        debian|ubuntu|linuxmint|zorin|pop)
            sudo apt update
            sudo apt install -y flatpak ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm flatpak ;;
        fedora)
            sudo dnf install -y flatpak ;;
        void)
            sudo xbps-install -Sy flatpak ;;
        opensuse*)
            sudo zypper install -y flatpak ;;
        alpine)
            sudo apk add flatpak ;;
        *)
            echo "[!] Distro desconhecida — tentando Flatpak genérico…"
            sudo apt install -y flatpak 2>/dev/null || true ;;
    esac

    echo "[+] Adicionando Flathub…"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# ====================================================================
# LISTA DE APPS POR CATEGORIA
# ====================================================================

# Comunicação
COMM_APPS_IDS=(
    "com.discordapp.Discord"
    "org.telegram.desktop"
    "com.slack.Slack"
    "us.zoom.Zoom"
)
COMM_APPS_NAMES=(
    "Discord"
    "Telegram"
    "Slack"
    "Zoom"
)

# Escritório
OFFICE_APPS_IDS=(
    "org.onlyoffice.desktopeditors"
    "org.libreoffice.LibreOffice"
)
OFFICE_APPS_NAMES=(
    "OnlyOffice"
    "LibreOffice"
)

# Navegadores
BROWSER_APPS_IDS=(
    "com.brave.Browser"
    "org.chromium.Chromium"
)
BROWSER_APPS_NAMES=(
    "Brave"
    "Chromium"
)

# Multimídia
MEDIA_APPS_IDS=(
    "org.videolan.VLC"
    "org.gimp.GIMP"
    "org.kde.kdenlive"
)
MEDIA_APPS_NAMES=(
    "VLC"
    "GIMP"
    "Kdenlive"
)

# Notas & Organização
NOTE_APPS_IDS=(
    "md.obsidian.Obsidian"
)
NOTE_APPS_NAMES=(
    "Obsidian"
)

# E-mail
MAIL_APPS_IDS=(
    "org.mozilla.Thunderbird"
)
MAIL_APPS_NAMES=(
    "Thunderbird"
)

# Unir tudo em listas gerais
ALL_IDS=(
    "${COMM_APPS_IDS[@]}"
    "${OFFICE_APPS_IDS[@]}"
    "${BROWSER_APPS_IDS[@]}"
    "${MEDIA_APPS_IDS[@]}"
    "${NOTE_APPS_IDS[@]}"
    "${MAIL_APPS_IDS[@]}"
)
ALL_NAMES=(
    "${COMM_APPS_NAMES[@]}"
    "${OFFICE_APPS_NAMES[@]}"
    "${BROWSER_APPS_NAMES[@]}"
    "${MEDIA_APPS_NAMES[@]}"
    "${NOTE_APPS_NAMES[@]}"
    "${MAIL_APPS_NAMES[@]}"
)

# ====================================================================
# MENU COM CATEGORIAS
# ====================================================================
while true; do
    clear

    echo "=========================================================="
    echo "       INSTALADOR DE PRODUTIVIDADE (FLATPAK)"
    echo "=========================================================="
    echo "Escolha múltiplos apps: exemplo →    1 2 5 10 13"
    echo ""
    echo "0) Instalar Flatpak"
    echo ""
    
    index=1

    echo "--- Comunicação ---"
    for i in "${COMM_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "--- Escritório ---"
    for i in "${OFFICE_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "--- Navegadores ---"
    for i in "${BROWSER_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "--- Multimídia ---"
    for i in "${MEDIA_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "--- Notas & Organização ---"
    for i in "${NOTE_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "--- E-mail ---"
    for i in "${MAIL_APPS_NAMES[@]}"; do
        echo "$index) $i"
        ((index++))
    done
    echo ""

    echo "99) Sair"
    echo "=========================================================="

    read -p "Escolha várias opções: " escolha

    [[ "$escolha" == "99" ]] && exit 0

    for item in $escolha; do
        if [[ "$item" == "0" ]]; then
            install_flatpak
            continue
        fi

        if [[ "$item" -ge 1 && "$item" -le ${#ALL_IDS[@]} ]]; then
            app_index=$((item-1))
            echo "[+] Instalando ${ALL_NAMES[$app_index]}..."
            flatpak install -y flathub "${ALL_IDS[$app_index]}"
        else
            echo "[!] Opção inválida: $item"
        fi
    done

    echo "=========================================================="
    echo " Instalação concluída! Pressione ENTER para continuar."
    echo "=========================================================="
    read
done
