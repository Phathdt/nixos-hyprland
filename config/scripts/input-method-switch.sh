#!/usr/bin/env bash

CURRENT_ENGINE=$(ibus engine)
ICON_VI="🇻🇳"
ICON_EN="🇺🇸"

if [[ "$CURRENT_ENGINE" == "Bamboo" ]]; then
    ibus engine xkb:us::eng
    notify-send "$ICON_EN English" "Switched to English keyboard" -t 2000 -i input-keyboard
    echo "EN"
else
    ibus engine Bamboo
    notify-send "$ICON_VI Tiếng Việt" "Switched to Vietnamese (Bamboo)" -t 2000 -i input-keyboard
    echo "VI"
fi
