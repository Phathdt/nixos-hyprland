#!/bin/bash

echo "=== SDDM Fix Script ==="
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run as root"
    echo "Usage: sudo ~/.config/scripts/fix-sddm.sh"
    exit 1
fi

echo "1. Stopping display manager..."
systemctl stop display-manager.service
systemctl stop sddm.service
sleep 2

echo "2. Checking for conflicting processes..."
pkill -f sddm || echo "No SDDM processes found"
pkill -f Xorg || echo "No Xorg processes found"
sleep 1

echo "3. Clearing display manager state..."
rm -f /tmp/.X*-lock 2>/dev/null || true
rm -f /tmp/.X11-unix/X* 2>/dev/null || true

echo "4. Reloading systemd..."
systemctl daemon-reload

echo "5. Checking Hyprland session file..."
if [ ! -f "/usr/share/wayland-sessions/hyprland.desktop" ]; then
    echo "Creating Hyprland session file..."
    mkdir -p /usr/share/wayland-sessions
    cat > /usr/share/wayland-sessions/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
fi

echo "6. Setting correct permissions..."
chmod 644 /usr/share/wayland-sessions/hyprland.desktop 2>/dev/null || true

echo "7. Restarting display manager..."
systemctl start display-manager.service

echo "8. Checking status..."
sleep 3
systemctl status display-manager.service --no-pager

echo
echo "=== Fix completed ==="
echo "If still having issues, check logs with:"
echo "  journalctl -u sddm.service -f"
echo "  ~/.config/scripts/debug-sddm.sh"
