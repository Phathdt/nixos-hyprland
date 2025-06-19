#!/usr/bin/env bash

CURRENT_ENGINE=$(ibus engine 2>/dev/null)

if [[ "$CURRENT_ENGINE" == "Bamboo" ]]; then
    echo '{"text": "🇻🇳", "tooltip": "Vietnamese (Bamboo)", "class": "vietnamese"}'
else
    echo '{"text": "🇺🇸", "tooltip": "English", "class": "english"}'
fi
