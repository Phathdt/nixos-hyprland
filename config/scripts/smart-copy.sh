#!/usr/bin/env bash

# Log file
LOG_FILE="/tmp/smart-copy.log"

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

echo "$(date): Smart Copy triggered" >> "$LOG_FILE"
echo "$(date): Active window class: '$active_window'" >> "$LOG_FILE"

# Check if it's a terminal application
case "$active_window" in
    "Alacritty"|"kitty"|"foot"|"wezterm"|"gnome-terminal"|"xterm"|"urxvt")
        echo "$(date): Detected terminal app - using Ctrl+Shift+C" >> "$LOG_FILE"
        wtype -M ctrl -M shift -k c -m shift -m ctrl
        echo "$(date): Executed: wtype -M ctrl -M shift -k c -m shift -m ctrl" >> "$LOG_FILE"
        ;;
    *)
        echo "$(date): Detected regular app - using Ctrl+C" >> "$LOG_FILE"
        wtype -M ctrl -k c -m ctrl
        echo "$(date): Executed: wtype -M ctrl -k c -m ctrl" >> "$LOG_FILE"
        ;;
esac

echo "$(date): Smart Copy completed" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
