#!/usr/bin/env bash

echo "=== Display Debug Information ==="
echo

echo "1. Available Display Outputs:"
ls /sys/class/drm/card*/card*/enabled 2>/dev/null | while read file; do
    connector=$(echo $file | sed 's|.*/\(.*\)/enabled|\1|')
    status=$(cat $file)
    echo "  $connector: $status"
done
echo

echo "2. Connected Displays:"
for connector in $(ls /sys/class/drm/card*/card*/ 2>/dev/null | grep -E '^(HDMI|DP|eDP|VGA)'); do
    path="/sys/class/drm/card*/card*/$connector"
    if [ -f "$path/status" ]; then
        status=$(cat "$path/status" 2>/dev/null)
        echo "  $connector: $status"
    fi
done
echo

echo "3. Hyprland Monitor Detection:"
if command -v hyprctl &> /dev/null; then
    hyprctl monitors all
else
    echo "  Hyprland not running or hyprctl not available"
fi
echo

echo "4. Xrandr Output (if available):"
if command -v xrandr &> /dev/null && [ -n "$DISPLAY" ]; then
    xrandr --listmonitors
else
    echo "  X11 not running or xrandr not available"
fi
echo

echo "5. Wayland Display Info:"
if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "  Wayland session detected: $WAYLAND_DISPLAY"
    if command -v wlr-randr &> /dev/null; then
        wlr-randr
    else
        echo "  wlr-randr not available"
    fi
else
    echo "  Not in Wayland session"
fi
echo

echo "6. DRM Devices:"
ls -la /dev/dri/
echo

echo "7. Graphics Driver Info:"
lsmod | grep -E "(i915|amdgpu|nvidia|nouveau|radeon)"
echo

echo "7.1. AMD GPU Info (if available):"
if command -v radeontop &> /dev/null; then
    echo "  AMD GPU detected - use 'radeontop' or 'amdgpu_top' for monitoring"
fi
if [ -f /sys/class/drm/card0/device/vendor ]; then
    vendor=$(cat /sys/class/drm/card0/device/vendor)
    if [ "$vendor" = "0x1002" ]; then
        echo "  AMD GPU detected (Vendor: $vendor)"
        if [ -f /sys/class/drm/card0/device/device ]; then
            device=$(cat /sys/class/drm/card0/device/device)
            echo "  Device ID: $device"
        fi
    fi
fi
echo

echo "8. DisplayPort Cable Detection:"
for dp in /sys/class/drm/card*/card*/DP-*; do
    if [ -d "$dp" ]; then
        connector=$(basename "$dp")
        if [ -f "$dp/status" ]; then
            status=$(cat "$dp/status")
            echo "  $connector: $status"
            if [ -f "$dp/enabled" ]; then
                enabled=$(cat "$dp/enabled")
                echo "    Enabled: $enabled"
            fi
        fi
    fi
done
echo

echo "9. Kernel Messages (last 20 lines about display):"
dmesg | grep -iE "(drm|display|dp|hdmi)" | tail -20
