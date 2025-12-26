#!/bin/bash

# RTL8188FU Firmware Installer for EmulationStation Tools Menu

clear

SCRIPT_NAME="Install RTL8188FU WiFi Firmware"
FIRMWARE_SOURCE="/roms/tools/rtl8188fufw.bin"
FIRMWARE_DEST="/lib/firmware/rtlwifi/"

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
        dialog --title "$title" --yesno "$message" 12 70
        return $?
    else
        echo "=== $title ==="
        echo "$message"
        read -p "Continuar? (s/n): " response
        [[ "$response" =~ ^[Ss]$ ]] && return 0 || return 1
    fi
}

# Welcome
if ! show_yesno "$SCRIPT_NAME" "Este script instala o firmware do adaptador WiFi USB Realtek RTL8188FU.\n\nVocê precisa ter:\n1. O arquivo rtl8188fufw.bin em /roms/tools/\n2. Permissão de root (será solicitada)\n\nBaixe o firmware de:\nhttps://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin\n\nDeseja continuar?"; then
    clear
    exit 0
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    show_message "Erro" "Este script precisa de permissão de root.\n\nPor favor, execute com sudo."
    clear
    exit 1
fi

# Check if firmware file exists
if [ ! -f "$FIRMWARE_SOURCE" ]; then
    show_message "Erro - Firmware não encontrado" "O arquivo rtl8188fufw.bin não foi encontrado em /roms/tools/\n\nPor favor:\n\n1. Baixe rtl8188fufw.bin de:\nhttps://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin\n\n2. Copie para /roms/tools/ no cartão SD\n\n3. Execute este script novamente."
    clear
    exit 1
fi

# Install firmware
{
    echo "10"
    echo "# Criando diretórios..."
    mkdir -p "$FIRMWARE_DEST"
    sleep 1

    echo "50"
    echo "# Copiando firmware..."
    cp "$FIRMWARE_SOURCE" "$FIRMWARE_DEST"
    chmod 644 "${FIRMWARE_DEST}/rtl8188fufw.bin"
    sleep 1

    echo "100"
    echo "# Concluído!"
    sleep 1
} | if [ $USE_DIALOG -eq 1 ]; then
    dialog --title "Instalando Firmware" --gauge "Preparando..." 7 60 0
fi

# Verify installation
if [ -f "${FIRMWARE_DEST}/rtl8188fufw.bin" ]; then
    # Check if adapter is connected
    ADAPTER_STATUS=""
    if lsusb 2>/dev/null | grep -q "0bda:f179"; then
        ADAPTER_STATUS="✓ ADAPTADOR RTL8188FU DETECTADO!\n\n"

        # Check for WiFi interface
        if ip link show 2>/dev/null | grep -q "wlan"; then
            ADAPTER_STATUS+="✓ INTERFACE WIFI ENCONTRADA!\n"
            ADAPTER_STATUS+="Parece que já está funcionando!\n\n"
        else
            ADAPTER_STATUS+="Aguarde alguns segundos para a interface aparecer...\n\n"
        fi
    fi

    show_message "Instalação Concluída!" "✓ Firmware instalado com sucesso!\n\nLocalização: ${FIRMWARE_DEST}/rtl8188fufw.bin\n\n${ADAPTER_STATUS}Próximos passos:\n1. Conecte seu adaptador WiFi USB RTL8188FU (se ainda não conectou)\n2. Aguarde alguns segundos\n3. Use o menu WiFi do dArkOS para conectar\n\nPara verificar:\n- Menu → Network Info\n- Ou via terminal: ip link show"
else
    show_message "Erro" "✗ Instalação falhou!\n\nO firmware não foi copiado corretamente.\n\nVerifique as permissões e tente novamente."
fi

clear
exit 0
