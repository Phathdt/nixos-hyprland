#!/usr/bin/env bash

# Log file
LOG_FILE="/tmp/smart-copy.log"

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

echo "$(date): Smart Copy triggered" >> "$LOG_FILE"
echo "$(date): Active window class: '$active_window'" >> "$LOG_FILE"

# Get clipboard content before copy
clipboard_before=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard BEFORE copy: '${clipboard_before:0:100}'" >> "$LOG_FILE"

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

# Wait a bit for clipboard to update
sleep 0.1

# Get clipboard content after copy
clipboard_after=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard AFTER copy: '${clipboard_after:0:100}'" >> "$LOG_FILE"

# Check if copy was successful
if [ "$clipboard_before" != "$clipboard_after" ]; then
    echo "$(date): ✅ Copy SUCCESS - clipboard changed" >> "$LOG_FILE"
else
    echo "$(date): ❌ Copy FAILED - clipboard unchanged" >> "$LOG_FILE"
fi

echo "$(date): Smart Copy completed" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
