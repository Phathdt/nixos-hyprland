#!/usr/bin/env bash

# Monitor for clicks outside the panel and close it
while true; do
    # Try to get window list, if it fails, use alternative method
    if eww get 2>/dev/null | grep -q "settings-panel" || pgrep -f "eww.*settings-panel" >/dev/null 2>&1; then
        # Check if panel is open and wait for click outside
        sleep 1

        # Get active window (if hyprctl is available)
        if command -v hyprctl >/dev/null 2>&1; then
            active_window=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class' 2>/dev/null)

            # If active window is not the panel, close it
            if [[ "$active_window" != "eww-settings-panel" && "$active_window" != "" && "$active_window" != "null" ]]; then
                eww close settings-panel 2>/dev/null
                break
            fi
        else
            # Fallback: close after 10 seconds if no hyprctl
            sleep 10
            eww close settings-panel 2>/dev/null
            break
        fi
    else
        break
    fi
done
