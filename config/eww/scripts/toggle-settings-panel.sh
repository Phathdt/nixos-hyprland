#!/usr/bin/env bash

# Check if panel is already open by trying to close it first
if eww close settings-panel 2>/dev/null; then
    # Panel was open and now closed
    echo "Panel closed"
else
    # Panel was not open, so open it
    eww open settings-panel
    # Start auto-close monitoring in background
    # ~/.config/eww/scripts/auto-close-panel.sh &
fi
