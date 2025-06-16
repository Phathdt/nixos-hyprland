#!/usr/bin/env bash

# Get current IBus engine
current_engine=$(ibus engine 2>/dev/null)

# Check if IBus is running
if ! pgrep -x "ibus-daemon" > /dev/null; then
    echo "🔤 EN"
    exit 0
fi

# Determine current input method and display appropriate icon/text
case "$current_engine" in
    "Bamboo")
        echo "🇻🇳 VI"
        ;;
    "xkb:us::eng"|"")
        echo "🔤 EN"
        ;;
    *)
        echo "🔤 EN"
        ;;
esac
