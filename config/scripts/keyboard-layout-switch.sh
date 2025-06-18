#!/usr/bin/env bash

# Auto-detect keyboard device name
KEYBOARD_DEVICE=$(hyprctl devices | grep -B 1 "Keyboard" | grep -v "Keyboard" | grep -v "^--$" | head -1 | xargs)

if [ -z "$KEYBOARD_DEVICE" ]; then
    notify-send "Error" "No keyboard device found" -t 2000
    echo "Error: No keyboard device found"
    exit 1
fi

echo "Using keyboard device: $KEYBOARD_DEVICE"

# Get current keyboard layout
current_layout=$(hyprctl devices | grep -A 10 "Keyboard" | grep "active keymap" | head -1 | awk '{print $3}')

echo "Current layout: $current_layout"

if [ "$current_layout" = "English" ] || [ "$current_layout" = "us" ]; then
    # Switch to Vietnamese
    echo "Switching to Vietnamese..."
    hyprctl switchxkblayout "$KEYBOARD_DEVICE" 1
    notify-send "Keyboard Layout" "Switched to Vietnamese" -t 1000
else
    # Switch to English
    echo "Switching to English..."
    hyprctl switchxkblayout "$KEYBOARD_DEVICE" 0
    notify-send "Keyboard Layout" "Switched to English" -t 1000
fi
