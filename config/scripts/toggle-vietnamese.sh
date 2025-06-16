#!/usr/bin/env bash

# Toggle between English and Vietnamese input methods using Fcitx5 with Unikey
current_im=$(fcitx5-remote -n 2>/dev/null)

if [ "$current_im" = "keyboard-us" ] || [ -z "$current_im" ]; then
    # Switch to Vietnamese (Unikey)
    fcitx5-remote -s unikey 2>/dev/null
    notify-send "Input Method" "Switched to Vietnamese (Unikey) 🇻🇳" -i input-keyboard
else
    # Switch to English
    fcitx5-remote -s keyboard-us 2>/dev/null
    notify-send "Input Method" "Switched to English 🔤" -i input-keyboard
fi

# Send signal to Waybar to update input method indicator
pkill -SIGRTMIN+8 waybar 2>/dev/null || true
