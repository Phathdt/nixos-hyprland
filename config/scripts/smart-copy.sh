#!/bin/bash

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

# Check if it's a terminal application
case "$active_window" in
    "Alacritty"|"kitty"|"foot"|"wezterm"|"gnome-terminal"|"xterm"|"urxvt")
        # Terminal application - use Ctrl+Shift+C
        wtype -M ctrl -M shift -k c -m shift -m ctrl
        ;;
    *)
        # Regular application - use Ctrl+C
        wtype -M ctrl -k c -m ctrl
        ;;
esac
