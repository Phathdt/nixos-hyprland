#!/usr/bin/env bash

# Quick Monitor Info - Shows current monitor details in notification

# Check if Hyprland is running
if ! command -v hyprctl >/dev/null 2>&1; then
    exit 1
fi

# Get monitor info
MONITOR_INFO=$(hyprctl monitors | grep -A5 "HDMI-A-1")
CURRENT_RES=$(echo "$MONITOR_INFO" | grep -o '[0-9]*x[0-9]*@[0-9]*' | head -1)
CURRENT_SCALE=$(echo "$MONITOR_INFO" | grep "scale:" | awk '{print $2}')

# Determine monitor type
case "${CURRENT_RES%@*}" in
    "3840x2160")
        MONITOR_TYPE="4K Monitor"
        RECOMMENDED_SCALE="1.0"
        ;;
    "3440x1440")
        MONITOR_TYPE="Ultrawide Monitor"
        RECOMMENDED_SCALE="1.0"
        ;;
    "2560x1440")
        MONITOR_TYPE="1440p Monitor"
        RECOMMENDED_SCALE="1.0"
        ;;
    "1920x1080")
        MONITOR_TYPE="1080p Monitor"
        RECOMMENDED_SCALE="1.0"
        ;;
    *)
        MONITOR_TYPE="Unknown Monitor"
        RECOMMENDED_SCALE="auto"
        ;;
esac

# Create notification message
MESSAGE="🖥️ Monitor: $MONITOR_TYPE
📐 Resolution: $CURRENT_RES
🔍 Current Scale: $CURRENT_SCALE
💡 Recommended Scale: $RECOMMENDED_SCALE

🔧 Press Super+Shift+M to auto-configure"

# Show notification
if command -v notify-send >/dev/null 2>&1; then
    notify-send "Monitor Information" "$MESSAGE" -t 5000
else
    echo "$MESSAGE"
fi
