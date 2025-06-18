#!/usr/bin/env bash

# Get current keyboard layout
current_layout=$(hyprctl devices | grep -A 10 "Keyboard" | grep "active keymap" | head -1 | awk '{print $3}')

if [ "$current_layout" = "English" ] || [ "$current_layout" = "us" ]; then
    # Switch to Vietnamese
    hyprctl switchxkblayout at-translated-set-2-keyboard 1
    notify-send "Keyboard Layout" "Switched to Vietnamese" -t 1000
else
    # Switch to English
    hyprctl switchxkblayout at-translated-set-2-keyboard 0
    notify-send "Keyboard Layout" "Switched to English" -t 1000
fi
