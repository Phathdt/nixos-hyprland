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
        echo "$(date): Detected regular app - trying multiple methods" >> "$LOG_FILE"

        # Method 1: Standard Ctrl+C
        echo "$(date): Method 1 - Standard Ctrl+C" >> "$LOG_FILE"
        wtype -M ctrl -k c -m ctrl
        sleep 0.2

        # Check if it worked
        clipboard_check1=$(wl-paste 2>/dev/null || echo "")
        if [ "$clipboard_before" != "$clipboard_check1" ]; then
            echo "$(date): Method 1 SUCCESS" >> "$LOG_FILE"
        else
            echo "$(date): Method 1 FAILED - trying Method 2" >> "$LOG_FILE"

            # Method 2: With longer delay
            wtype -M ctrl -k c -m ctrl
            sleep 0.5

            clipboard_check2=$(wl-paste 2>/dev/null || echo "")
            if [ "$clipboard_before" != "$clipboard_check2" ]; then
                echo "$(date): Method 2 SUCCESS" >> "$LOG_FILE"
            else
                echo "$(date): Method 2 FAILED - trying Method 3" >> "$LOG_FILE"

                # Method 3: Alternative approach
                wtype -k ctrl+c
                sleep 0.3
                echo "$(date): Method 3 - Alternative wtype syntax" >> "$LOG_FILE"
            fi
        fi
        ;;
esac

# Wait a bit for clipboard to update
sleep 0.3

# Get clipboard content after copy
clipboard_after=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard AFTER copy: '${clipboard_after:0:100}'" >> "$LOG_FILE"

# Check if copy was successful
if [ "$clipboard_before" != "$clipboard_after" ]; then
    echo "$(date): ✅ Copy SUCCESS - clipboard changed" >> "$LOG_FILE"
else
    echo "$(date): ❌ Copy FAILED - trying fallback methods" >> "$LOG_FILE"

    # Fallback 1: Try ydotool if available
    if command -v ydotool &> /dev/null; then
        echo "$(date): Fallback 1 - Using ydotool" >> "$LOG_FILE"
        ydotool key ctrl+c
        sleep 0.3
        clipboard_fallback1=$(wl-paste 2>/dev/null || echo "")
        if [ "$clipboard_before" != "$clipboard_fallback1" ]; then
            echo "$(date): ✅ Fallback 1 SUCCESS with ydotool" >> "$LOG_FILE"
        else
            echo "$(date): ❌ Fallback 1 FAILED" >> "$LOG_FILE"
        fi
    fi

    # Fallback 2: Try xdotool if available (for X11 compatibility)
    if command -v xdotool &> /dev/null; then
        echo "$(date): Fallback 2 - Using xdotool" >> "$LOG_FILE"
        xdotool key ctrl+c
        sleep 0.3
        clipboard_fallback2=$(wl-paste 2>/dev/null || echo "")
        if [ "$clipboard_before" != "$clipboard_fallback2" ]; then
            echo "$(date): ✅ Fallback 2 SUCCESS with xdotool" >> "$LOG_FILE"
        else
            echo "$(date): ❌ Fallback 2 FAILED" >> "$LOG_FILE"
        fi
    fi

    # Final check
    clipboard_final=$(wl-paste 2>/dev/null || echo "")
    if [ "$clipboard_before" != "$clipboard_final" ]; then
        echo "$(date): ✅ FINAL SUCCESS - clipboard changed after fallbacks" >> "$LOG_FILE"
    else
        echo "$(date): ❌ ALL METHODS FAILED - clipboard still unchanged" >> "$LOG_FILE"
        echo "$(date): Suggestion: Check if text is selected or try different app" >> "$LOG_FILE"
    fi
fi

echo "$(date): Smart Copy completed" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
