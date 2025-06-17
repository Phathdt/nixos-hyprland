#!/usr/bin/env bash

# Log file
LOG_FILE="/tmp/smart-paste.log"

# Check available tools
echo "$(date): ===== PASTE TOOL AVAILABILITY CHECK =====" >> "$LOG_FILE"
echo "$(date): wtype: $(command -v wtype || echo 'NOT FOUND')" >> "$LOG_FILE"
echo "$(date): ydotool: $(command -v ydotool || echo 'NOT FOUND')" >> "$LOG_FILE"
echo "$(date): xdotool: $(command -v xdotool || echo 'NOT FOUND')" >> "$LOG_FILE"

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

echo "$(date): Smart Paste triggered" >> "$LOG_FILE"
echo "$(date): Active window class: '$active_window'" >> "$LOG_FILE"

# Get clipboard content before paste
clipboard_content=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard content to paste: '${clipboard_content:0:100}'" >> "$LOG_FILE"

# Check if clipboard is empty
if [ -z "$clipboard_content" ]; then
    echo "$(date): ⚠️  WARNING - Clipboard is empty, nothing to paste" >> "$LOG_FILE"
else
    echo "$(date): ✅ Clipboard has content (${#clipboard_content} chars)" >> "$LOG_FILE"
fi

# Check if it's a terminal application
case "$active_window" in
    "Alacritty"|"kitty"|"foot"|"wezterm"|"gnome-terminal"|"xterm"|"urxvt")
        echo "$(date): Detected terminal app - using Ctrl+Shift+V" >> "$LOG_FILE"
        wtype -M ctrl -M shift -k v -m shift -m ctrl
        echo "$(date): Executed: wtype -M ctrl -M shift -k v -m shift -m ctrl" >> "$LOG_FILE"
        ;;
    *)
                        echo "$(date): Detected regular app - trying paste methods sequentially" >> "$LOG_FILE"

        # Ensure window focus by clicking (if possible)
        echo "$(date): Attempting to ensure window focus..." >> "$LOG_FILE"
        if command -v ydotool &> /dev/null; then
            # Get window position and click center
            window_info=$(hyprctl activewindow -j)
            if [ $? -eq 0 ]; then
                echo "$(date): Clicking window to ensure focus" >> "$LOG_FILE"
                # Simple click in the middle of screen - adjust as needed
                ydotool click 0xC0 # Left click
                sleep 0.2
            fi
        fi

        # Method 1: Standard Ctrl+V
        echo "$(date): Method 1 - Standard Ctrl+V" >> "$LOG_FILE"
        wtype -M ctrl -k v -m ctrl
        sleep 0.5
        echo "$(date): Method 1 completed, waiting..." >> "$LOG_FILE"

        # Method 2: Alternative wtype syntax (only if Method 1 might have failed)
        echo "$(date): Method 2 - Alternative wtype syntax" >> "$LOG_FILE"
        wtype -k ctrl+v
        sleep 0.5
        echo "$(date): Method 2 completed, waiting..." >> "$LOG_FILE"

        # Method 3: Try ydotool if available
        if command -v ydotool &> /dev/null; then
            echo "$(date): Method 3 - Using ydotool" >> "$LOG_FILE"
            ydotool key ctrl+v
            sleep 0.5
            echo "$(date): Method 3 completed, waiting..." >> "$LOG_FILE"
        fi

        # Method 4: Try xdotool if available
        if command -v xdotool &> /dev/null; then
            echo "$(date): Method 4 - Using xdotool" >> "$LOG_FILE"
            xdotool key ctrl+v
            sleep 0.5
            echo "$(date): Method 4 completed, waiting..." >> "$LOG_FILE"
        fi

        # Method 5: Direct text injection using multiple approaches
        if [ -n "$clipboard_content" ]; then
            echo "$(date): Method 5 - Direct text injection with multiple approaches" >> "$LOG_FILE"
            sleep 0.5  # Give time for previous methods to settle

            # Approach A: wtype pipe
            echo "$(date): 5A - wtype pipe method" >> "$LOG_FILE"
            echo "$clipboard_content" | wtype -
            sleep 0.3

            # Approach B: wtype direct
            echo "$(date): 5B - wtype direct method" >> "$LOG_FILE"
            wtype "$clipboard_content"
            sleep 0.3

            # Approach C: ydotool type (most compatible)
            if command -v ydotool &> /dev/null; then
                echo "$(date): 5C - ydotool type method" >> "$LOG_FILE"
                ydotool type "$clipboard_content"
                sleep 0.3
            fi

            echo "$(date): All direct injection methods attempted: '${clipboard_content:0:50}'" >> "$LOG_FILE"
        fi
        ;;
esac

# Final verification - check if paste was successful
echo "$(date): Attempting to verify paste success..." >> "$LOG_FILE"

# For code editors, we can try to get current line content (if possible)
if [[ "$active_window" == *"Cursor"* ]] || [[ "$active_window" == *"code"* ]]; then
    echo "$(date): Code editor detected - paste verification limited" >> "$LOG_FILE"
    echo "$(date): If text didn't appear, try Method 5 (direct injection) manually" >> "$LOG_FILE"
fi

echo "$(date): Smart Paste completed" >> "$LOG_FILE"
echo "$(date): Summary - Tried multiple methods for: '${clipboard_content:0:30}'" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
