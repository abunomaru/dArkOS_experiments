#!/bin/bash

# RTL8188FU Firmware Installer for Steam Deck
# This script downloads the firmware and installs it directly to the R36S SD card

set -e

echo "=== RTL8188FU Firmware Installer for Steam Deck ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script needs root access to mount and modify the SD card."
  echo "Please run with sudo:"
  echo "  sudo $0"
  exit 1
fi

# Download firmware
FIRMWARE_URL="https://github.com/lwfinger/rtl8188fu/raw/master/firmware/rtl8188fufw.bin"
FIRMWARE_FILE="rtl8188fufw.bin"

echo "Downloading RTL8188FU firmware..."
curl -L "$FIRMWARE_URL" -o "$FIRMWARE_FILE"

if [ ! -f "$FIRMWARE_FILE" ]; then
  echo "Error: Failed to download firmware!"
  exit 1
fi

echo "✓ Firmware downloaded: $FIRMWARE_FILE"
echo ""

# Find R36S SD card
echo "Looking for R36S SD card..."
echo ""
echo "Available block devices:"
lsblk -p

echo ""
read -p "Enter the R36S SD card device (e.g., /dev/mmcblk0 or /dev/sda): " SD_DEVICE

if [ ! -b "$SD_DEVICE" ]; then
  echo "Error: $SD_DEVICE is not a valid block device!"
  exit 1
fi

# Find the root partition (usually partition 4)
ROOT_PARTITION="${SD_DEVICE}p4"
if [ ! -b "$ROOT_PARTITION" ]; then
  # Try without 'p' (for /dev/sdX devices)
  ROOT_PARTITION="${SD_DEVICE}4"
fi

if [ ! -b "$ROOT_PARTITION" ]; then
  echo "Error: Could not find root partition!"
  echo "Expected: ${SD_DEVICE}p4 or ${SD_DEVICE}4"
  exit 1
fi

echo "Using root partition: $ROOT_PARTITION"
echo ""

# Create mount point
MOUNT_POINT="/tmp/r36s_root"
mkdir -p "$MOUNT_POINT"

# Mount the partition
echo "Mounting $ROOT_PARTITION to $MOUNT_POINT..."
mount "$ROOT_PARTITION" "$MOUNT_POINT"

if [ ! -d "$MOUNT_POINT/lib/firmware" ]; then
  echo "Error: Mounted partition does not look like a Linux root filesystem!"
  umount "$MOUNT_POINT"
  exit 1
fi

echo "✓ Mounted successfully"
echo ""

# Create firmware directories
echo "Creating firmware directories..."
mkdir -p "$MOUNT_POINT/lib/firmware/rtlwifi"

# Copy firmware
echo "Installing firmware..."
cp "$FIRMWARE_FILE" "$MOUNT_POINT/lib/firmware/rtlwifi/"
chmod 644 "$MOUNT_POINT/lib/firmware/rtlwifi/$FIRMWARE_FILE"

echo "✓ Firmware installed to /lib/firmware/rtlwifi/$FIRMWARE_FILE"
echo ""

# Verify
if [ -f "$MOUNT_POINT/lib/firmware/rtlwifi/$FIRMWARE_FILE" ]; then
  echo "✓ Verification successful!"
  ls -lh "$MOUNT_POINT/lib/firmware/rtlwifi/$FIRMWARE_FILE"
else
  echo "✗ Verification failed!"
fi

# Unmount
echo ""
echo "Unmounting..."
sync
umount "$MOUNT_POINT"

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "Next steps:"
echo "1. Eject the SD card from Steam Deck"
echo "2. Insert it back into R36S"
echo "3. Boot R36S"
echo "4. Connect your RTL8188FU WiFi adapter"
echo "5. WiFi should work automatically!"
echo ""
echo "To verify on R36S:"
echo "  lsusb | grep 0bda:f179"
echo "  dmesg | grep rtl8188"
echo "  ip link show"
echo ""
