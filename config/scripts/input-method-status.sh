#!/usr/bin/env bash

# Get current Fcitx5 input method
current_im=$(fcitx5-remote -n 2>/dev/null)

# Check if Fcitx5 is running
if ! pgrep -x "fcitx5" > /dev/null; then
    echo "🔤 EN"
    exit 0
fi

# Determine current input method and display appropriate icon/text
case "$current_im" in
    "unikey"|"Unikey")
        echo "🇻🇳 VI"
        ;;
    "keyboard-us"|"")
        echo "🔤 EN"
        ;;
    *)
        echo "🔤 EN"
        ;;
esac
