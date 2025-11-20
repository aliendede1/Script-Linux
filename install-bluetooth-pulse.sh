#!/usr/bin/env bash

set -e

echo "=== Instalando Bluetooth + PulseAudio no Void Linux ==="

# Atualiza repositórios
sudo xbps-install -S

# Instalar PulseAudio e suporte Bluetooth
sudo xbps-install -y pulseaudio pulseaudio-utils pulseaudio-bluetooth

# Instalar pacotes Bluetooth
sudo xbps-install -y bluez bluez-tools

# Ativar serviço Bluetooth
sudo ln -sf /etc/sv/bluetoothd /var/service/

# Reiniciar PulseAudio
echo "Reiniciando PulseAudio..."
pulseaudio -k || true
pulseaudio --start

echo "=== Feito! Reinicie o PC para garantir o funcionamento. ==="
echo "Use 'bluetoothctl' para parear dispositivos."
