#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Show clipboard history with rofi
cliphist list | rofi -dmenu -i -p "Clipboard History" \
    -theme-str 'window {width: 600px; height: 400px;}' \
    -theme-str 'listview {lines: 10;}' \
    -auto-select \
    -no-lazy-grab \
    -format 's' | cliphist decode | wl-copy
