#!/usr/bin/env bash

# Log file
LOG_FILE="/tmp/smart-copy.log"

# Check available tools
echo "$(date): ===== TOOL AVAILABILITY CHECK =====" >> "$LOG_FILE"
echo "$(date): wtype: $(command -v wtype || echo 'NOT FOUND')" >> "$LOG_FILE"
echo "$(date): ydotool: $(command -v ydotool || echo 'NOT FOUND')" >> "$LOG_FILE"
echo "$(date): xdotool: $(command -v xdotool || echo 'NOT FOUND')" >> "$LOG_FILE"
echo "$(date): wl-paste: $(command -v wl-paste || echo 'NOT FOUND')" >> "$LOG_FILE"

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

echo "$(date): Smart Copy triggered" >> "$LOG_FILE"
echo "$(date): Active window class: '$active_window'" >> "$LOG_FILE"

# Get clipboard content before copy
clipboard_before=$(wl-paste 2>/dev/null || echo "")
echo "$(date): Clipboard BEFORE copy: '${clipboard_before:0:100}'" >> "$LOG_FILE"

# Check if there's any selected text (attempt to detect)
echo "$(date): Attempting to detect text selection..." >> "$LOG_FILE"

# For Chrome/browsers - try to select all first, then copy selection
if [[ "$active_window" == *"chrome"* ]] || [[ "$active_window" == *"Chrome"* ]] || [[ "$active_window" == *"firefox"* ]] || [[ "$active_window" == *"Firefox"* ]]; then
    echo "$(date): Detected browser - will try Ctrl+A first to ensure selection" >> "$LOG_FILE"
    # First select all text in current field/area
    wtype -M ctrl -k a -m ctrl
    sleep 0.1
fi

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

    # Fallback 3: Try primary selection (middle-click)
    echo "$(date): Fallback 3 - Checking primary selection" >> "$LOG_FILE"
    primary_selection=$(wl-paste --primary 2>/dev/null || echo "")
    if [ -n "$primary_selection" ] && [ "$primary_selection" != "$clipboard_before" ]; then
        echo "$(date): Found content in primary selection: '${primary_selection:0:100}'" >> "$LOG_FILE"
        # Copy primary to clipboard
        echo "$primary_selection" | wl-copy
        echo "$(date): ✅ Fallback 3 SUCCESS - copied from primary selection" >> "$LOG_FILE"
    else
        echo "$(date): ❌ Fallback 3 FAILED - no primary selection" >> "$LOG_FILE"
    fi

    # Final check
    clipboard_final=$(wl-paste 2>/dev/null || echo "")
    if [ "$clipboard_before" != "$clipboard_final" ]; then
        echo "$(date): ✅ FINAL SUCCESS - clipboard changed after fallbacks" >> "$LOG_FILE"
        echo "$(date): Final clipboard content: '${clipboard_final:0:100}'" >> "$LOG_FILE"
    else
        echo "$(date): ❌ ALL METHODS FAILED - clipboard still unchanged" >> "$LOG_FILE"
        echo "$(date): Suggestions:" >> "$LOG_FILE"
        echo "$(date): 1. Make sure text is selected before copying" >> "$LOG_FILE"
        echo "$(date): 2. Try using native app shortcuts (Ctrl+C manually)" >> "$LOG_FILE"
        echo "$(date): 3. Check if app has copy restrictions" >> "$LOG_FILE"
    fi
fi

echo "$(date): Smart Copy completed" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
