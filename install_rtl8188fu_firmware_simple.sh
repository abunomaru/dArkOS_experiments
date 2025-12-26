#!/bin/bash

# RTL8188FU Firmware Installer - Simple version for R36S
# Place rtl8188fufw.bin in /roms/tools/ and run this script

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

FIRMWARE_SOURCE="/roms/tools/rtl8188fufw.bin"
FIRMWARE_DEST="/lib/firmware/rtlwifi/"

echo "=== RTL8188FU Firmware Installer ==="
echo ""

# Check if firmware file exists
if [ ! -f "$FIRMWARE_SOURCE" ]; then
  echo "Error: Firmware file not found!"
  echo ""
  echo "Please download rtl8188fufw.bin and place it in /roms/tools/"
  echo ""
  echo "Download from:"
  echo "https://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin"
  echo ""
  exit 1
fi

# Create directory
echo "Creating firmware directory..."
mkdir -p "$FIRMWARE_DEST"

# Copy firmware
echo "Installing firmware..."
cp "$FIRMWARE_SOURCE" "$FIRMWARE_DEST"
chmod 644 "${FIRMWARE_DEST}/rtl8188fufw.bin"

# Verify
if [ -f "${FIRMWARE_DEST}/rtl8188fufw.bin" ]; then
  echo ""
  echo "✓ Firmware installed successfully!"
  echo ""
  echo "Location: ${FIRMWARE_DEST}/rtl8188fufw.bin"
  echo ""
  echo "Now connect your RTL8188FU WiFi adapter and it should work!"
  echo ""
else
  echo ""
  echo "✗ Installation failed!"
  echo ""
  exit 1
fi
