#!/usr/bin/env bash

# Auto-detect keyboard device name
KEYBOARD_DEVICE=$(hyprctl devices | grep -B 1 "Keyboard" | grep -v "Keyboard" | grep -v "^--$" | head -1 | xargs)

if [ -z "$KEYBOARD_DEVICE" ]; then
    notify-send "Error" "No keyboard device found" -t 2000
    echo "Error: No keyboard device found"
    exit 1
fi

echo "Using keyboard device: $KEYBOARD_DEVICE"

# Simple keyboard layout toggle
hyprctl switchxkblayout "$KEYBOARD_DEVICE" next

# Show notification
layout=$(hyprctl devices | grep -A 10 "Keyboard" | grep "active keymap" | head -1 | awk '{print $3}')
notify-send "Layout" "Current: $layout" -t 1000
