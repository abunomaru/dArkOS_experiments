#!/bin/bash

# RTL8188FU WiFi Adapter Quick Setup for dArkOS
# Just adds USB rules and tests if adapter works without external driver

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "=== RTL8188FU WiFi Adapter Quick Setup ==="
echo ""

# Add udev rule for RTL8188FU
echo "Adding USB device rules..."
if ! grep -q "0bda.*f179" /etc/udev/rules.d/40-usb_modeswitch.rules 2>/dev/null; then
  # Backup existing file
  if [ -f /etc/udev/rules.d/40-usb_modeswitch.rules ]; then
    cp /etc/udev/rules.d/40-usb_modeswitch.rules /etc/udev/rules.d/40-usb_modeswitch.rules.backup
    echo "Backup created: /etc/udev/rules.d/40-usb_modeswitch.rules.backup"
  fi

  # Add RTL8188FU rule before the end label
  sed -i '/LABEL="end_modeswitch"/i \
# Realtek RTL8188FTV/RTL8188FU 802.11n USB WiFi Adapter\n\
#   Direct WiFi mode, no mode switching needed\n\
ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="f179"\n' /etc/udev/rules.d/40-usb_modeswitch.rules

  echo "✓ USB rules added."
else
  echo "✓ USB rules already exist."
fi

# Reload udev rules
echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Now test your WiFi adapter:"
echo ""
echo "1. Connect your RTL8188FU USB WiFi adapter"
echo ""
echo "2. Wait a few seconds, then check:"
echo "   lsusb | grep 0bda:f179"
echo ""
echo "3. Check if WiFi interface appeared:"
echo "   ip link show"
echo "   iwconfig"
echo ""
echo "4. Check kernel modules loaded:"
echo "   lsmod | grep -E 'rtl|8188'"
echo ""
echo "5. Check kernel messages:"
echo "   dmesg | tail -20"
echo ""
echo "If you see a wlan interface, it works!"
echo "Use the WiFi menu in dArkOS to connect."
echo ""
echo "If it doesn't work, you'll need the full driver installation."
echo ""
