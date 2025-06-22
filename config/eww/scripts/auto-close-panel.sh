#!/usr/bin/env bash

# Monitor for clicks outside the panel and close it
while true; do
    if eww windows | grep -q "settings-panel"; then
        # Check if panel is open and wait for click outside
        sleep 0.5

        # Get active window
        active_window=$(hyprctl activewindow -j | jq -r '.class')

        # If active window is not the panel, close it
        if [[ "$active_window" != "eww-settings-panel" && "$active_window" != "" ]]; then
            eww close settings-panel
            break
        fi
    else
        break
    fi
done
