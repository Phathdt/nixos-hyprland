#!/usr/bin/env bash

# Kill any existing rofi instances
pkill rofi 2>/dev/null
sleep 0.1

# Run wifi menu in background to avoid blocking Waybar
(
    # Set environment for rofi
    export DISPLAY="${DISPLAY:-:0}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

    # Run the actual wifi menu
    bash ~/.config/scripts/wifi-menu.sh
) &

# Detach from parent process
