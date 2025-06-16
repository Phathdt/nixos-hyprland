#!/usr/bin/env bash

# Toggle between English and Vietnamese input methods
# Based on official ibus-bamboo documentation
current_engine=$(ibus engine 2>/dev/null)

if [ "$current_engine" = "xkb:us::eng" ] || [ -z "$current_engine" ]; then
    # Switch to Vietnamese (Bamboo)
    ibus engine Bamboo 2>/dev/null
    notify-send "Input Method" "Switched to Vietnamese (Bamboo) 🇻🇳" -i input-keyboard
else
    # Switch to English
    ibus engine xkb:us::eng 2>/dev/null
    notify-send "Input Method" "Switched to English 🔤" -i input-keyboard
fi

# Send signal to Waybar to update input method indicator
pkill -SIGRTMIN+8 waybar 2>/dev/null || true
