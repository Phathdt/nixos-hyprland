#!/bin/bash

# Get active window class
active_window=$(hyprctl activewindow -j | jq -r '.class')

# Check if it's a terminal application
case "$active_window" in
    "Alacritty"|"kitty"|"foot"|"wezterm"|"gnome-terminal"|"xterm"|"urxvt")
        # Terminal application - use Ctrl+Shift+V
        wtype -M ctrl -M shift -k v -m shift -m ctrl
        ;;
    *)
        # Regular application - use Ctrl+V
        wtype -M ctrl -k v -m ctrl
        ;;
esac
