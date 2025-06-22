#!/usr/bin/env bash

if eww windows | grep -q "settings-panel"; then
    eww close settings-panel
else
    eww open settings-panel
    # Start auto-close monitoring in background
    ~/.config/eww/scripts/auto-close-panel.sh &
fi
