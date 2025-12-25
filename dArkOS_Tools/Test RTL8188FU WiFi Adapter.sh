#!/bin/bash

# RTL8188FU WiFi Adapter Quick Test for EmulationStation Tools Menu

clear

SCRIPT_NAME="Test RTL8188FU WiFi Adapter"

# Check if dialog is available
if command -v dialog &> /dev/null; then
    USE_DIALOG=1
else
    USE_DIALOG=0
fi

show_message() {
    local title="$1"
    local message="$2"
    if [ $USE_DIALOG -eq 1 ]; then
        dialog --title "$title" --msgbox "$message" 15 70
    else
        echo "=== $title ==="
        echo "$message"
        echo ""
        read -p "Pressione ENTER para continuar..."
    fi
}

show_yesno() {
    local title="$1"
    local message="$2"
    if [ $USE_DIALOG -eq 1 ]; then
        dialog --title "$title" --yesno "$message" 10 60
        return $?
    else
        echo "=== $title ==="
        echo "$message"
        read -p "Continuar? (s/n): " response
        [[ "$response" =~ ^[Ss]$ ]] && return 0 || return 1
    fi
}

# Welcome
if ! show_yesno "$SCRIPT_NAME" "Este script configura o sistema para reconhecer adaptadores WiFi USB Realtek RTL8188FU (VID:0bda PID:f179).\n\nEle apenas adiciona regras USB - NÃO instala drivers.\n\nSe o adaptador não funcionar após este teste, você precisará instalar o driver completo.\n\nDeseja continuar?"; then
    clear
    exit 0
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    show_message "Erro" "Este script precisa de permissão de root.\n\nPor favor, execute com sudo."
    clear
    exit 1
fi

# Add udev rules
{
    echo "10"
    echo "# Adicionando regras USB..."
    sleep 1

    if ! grep -q "0bda.*f179" /etc/udev/rules.d/40-usb_modeswitch.rules 2>/dev/null; then
        if [ -f /etc/udev/rules.d/40-usb_modeswitch.rules ]; then
            cp /etc/udev/rules.d/40-usb_modeswitch.rules /etc/udev/rules.d/40-usb_modeswitch.rules.backup
        fi

        sed -i '/LABEL="end_modeswitch"/i \
# Realtek RTL8188FTV/RTL8188FU 802.11n USB WiFi Adapter\n\
#   Direct WiFi mode, no mode switching needed\n\
ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="f179"\n' /etc/udev/rules.d/40-usb_modeswitch.rules
    fi

    echo "50"
    echo "# Recarregando regras udev..."
    udevadm control --reload-rules
    udevadm trigger
    sleep 1

    echo "100"
    echo "# Concluído!"
    sleep 1
} | if [ $USE_DIALOG -eq 1 ]; then
    dialog --title "Configurando" --gauge "Preparando..." 7 60 0
fi

# Instructions
INSTRUCTIONS="Configuração concluída!\n\n"
INSTRUCTIONS+="PRÓXIMOS PASSOS:\n\n"
INSTRUCTIONS+="1. Conecte seu adaptador WiFi USB RTL8188FU\n\n"
INSTRUCTIONS+="2. Aguarde alguns segundos\n\n"
INSTRUCTIONS+="3. Verifique se apareceu uma interface WiFi:\n"
INSTRUCTIONS+="   - Vá no menu WiFi do dArkOS\n"
INSTRUCTIONS+="   - Ou via terminal: ip link show\n\n"

# Check if adapter is already connected
if lsusb 2>/dev/null | grep -q "0bda:f179"; then
    INSTRUCTIONS+="✓ ADAPTADOR DETECTADO!\n"
    INSTRUCTIONS+="Seu RTL8188FU foi encontrado.\n\n"

    # Check for WiFi interface
    if ip link show 2>/dev/null | grep -q "wlan"; then
        INSTRUCTIONS+="✓ INTERFACE WIFI ENCONTRADA!\n"
        INSTRUCTIONS+="Parece que já está funcionando!\n"
        INSTRUCTIONS+="Use o menu WiFi para conectar.\n"
    else
        INSTRUCTIONS+="⚠ Interface WiFi não encontrada.\n"
        INSTRUCTIONS+="Você pode precisar do driver completo.\n"
        INSTRUCTIONS+="Use: 'Install RTL8188FU WiFi Driver' no menu Tools.\n"
    fi
else
    INSTRUCTIONS+="⚠ Adaptador não detectado ainda.\n"
    INSTRUCTIONS+="Conecte-o e aguarde alguns segundos.\n"
fi

show_message "Teste Concluído" "$INSTRUCTIONS"

clear
exit 0
