#!/bin/bash

echo "=== SDDM Debug Information ==="
echo

echo "1. SDDM Service Status:"
systemctl status sddm.service --no-pager
echo

echo "2. Display Manager Service:"
systemctl status display-manager.service --no-pager
echo

echo "3. Available Sessions:"
ls -la /usr/share/wayland-sessions/ 2>/dev/null || echo "No Wayland sessions found"
ls -la /usr/share/xsessions/ 2>/dev/null || echo "No X sessions found"
echo

echo "4. Hyprland Session File:"
if [ -f "/usr/share/wayland-sessions/hyprland.desktop" ]; then
    echo "Found Hyprland session:"
    cat /usr/share/wayland-sessions/hyprland.desktop
else
    echo "Hyprland session file not found!"
fi
echo

echo "5. SDDM Configuration:"
if [ -f "/etc/sddm.conf" ]; then
    echo "SDDM config exists:"
    cat /etc/sddm.conf
else
    echo "No SDDM config found"
fi
echo

echo "6. Current Session Info:"
echo "Current user: $(whoami)"
echo "Current session: $XDG_SESSION_TYPE"
echo "Display: $DISPLAY"
echo "Wayland display: $WAYLAND_DISPLAY"
echo

echo "7. Journal Logs (SDDM errors):"
journalctl -u sddm.service --since "10 minutes ago" --no-pager | tail -20
echo

echo "8. Graphics Driver Status:"
lsmod | grep -E "(amdgpu|i915|nvidia|nouveau)"
echo

echo "9. TTY Status:"
who
echo

echo "10. Systemd Default Target:"
systemctl get-default
echo

echo "11. Display Manager Target:"
systemctl status graphical.target --no-pager
