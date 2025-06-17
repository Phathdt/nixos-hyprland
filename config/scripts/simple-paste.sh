#!/usr/bin/env bash

# Log file
LOG_FILE="/tmp/simple-paste.log"

echo "$(date): ===== SIMPLE PASTE STARTED =====" >> "$LOG_FILE"

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')
echo "$(date): Active window: '$active_window'" >> "$LOG_FILE"

# Get clipboard content
clipboard_content=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard content: '${clipboard_content:0:100}'" >> "$LOG_FILE"

# Check if clipboard has content
if [ -z "$clipboard_content" ]; then
    echo "$(date): ❌ ERROR - Clipboard is empty" >> "$LOG_FILE"
    notify-send "Paste Error" "Clipboard is empty"
    exit 1
fi

echo "$(date): ✅ Clipboard has content (${#clipboard_content} chars)" >> "$LOG_FILE"

# Direct text injection - most reliable method
echo "$(date): Using direct text injection..." >> "$LOG_FILE"
echo "$clipboard_content" | wtype -

echo "$(date): ✅ Text injected successfully: '${clipboard_content:0:50}'" >> "$LOG_FILE"
echo "$(date): ===== SIMPLE PASTE COMPLETED =====" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
