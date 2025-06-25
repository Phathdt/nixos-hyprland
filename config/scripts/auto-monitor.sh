#!/usr/bin/env bash

# Lightweight Auto Monitor Configuration for Hyprland
# Runs on startup to detect and configure monitor scaling

# Wait for Hyprland to fully initialize
sleep 2

# Check if Hyprland is running
if ! command -v hyprctl >/dev/null 2>&1; then
    exit 1
fi

# Get current monitor resolution for HDMI-A-1
CURRENT_RES=$(hyprctl monitors | grep -A3 "HDMI-A-1" | grep -o '[0-9]*x[0-9]*' | head -1)

# Apply appropriate scaling based on resolution
case "$CURRENT_RES" in
    "3840x2160")
        # 4K Monitor - run at 2880x1620 for crisp display (no scaling blur)
        hyprctl keyword monitor HDMI-A-1,2880x1620@60,0x0,1.0
        hyprctl keyword env GDK_SCALE,1
        hyprctl keyword env GDK_DPI_SCALE,1
        hyprctl keyword env QT_SCALE_FACTOR,1
        ;;
    "3440x1440")
        # Ultrawide Monitor - native scaling
        hyprctl keyword monitor HDMI-A-1,3440x1440@70,0x0,1.0
        hyprctl keyword env GDK_SCALE,1
        hyprctl keyword env GDK_DPI_SCALE,1
        hyprctl keyword env QT_SCALE_FACTOR,1
        ;;
    "2560x1440")
        # 1440p Monitor - native scaling
        hyprctl keyword monitor HDMI-A-1,2560x1440@60,0x0,1.0
        hyprctl keyword env GDK_SCALE,1
        hyprctl keyword env GDK_DPI_SCALE,1
        hyprctl keyword env QT_SCALE_FACTOR,1
        ;;
    "1920x1080")
        # 1080p Monitor - native scaling
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1.0
        hyprctl keyword env GDK_SCALE,1
        hyprctl keyword env GDK_DPI_SCALE,1
        hyprctl keyword env QT_SCALE_FACTOR,1
        ;;
esac
