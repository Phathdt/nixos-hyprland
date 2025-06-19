#!/usr/bin/env bash

CACHE_FILE="/tmp/fcitx5_state"
CURRENT_IM=""

get_current_im() {
    ~/.config/scripts/fcitx5-fallback.sh -n 2>/dev/null || echo "keyboard-us"
}

send_notification() {
    local im_name="$1"
    local icon=""
    local message=""

    case "$im_name" in
        "unikey")
            icon="input-keyboard"
            message="🇻🇳 Vietnamese Input (Unikey)"
            ;;
        "keyboard-us"|*)
            icon="input-keyboard"
            message="🇺🇸 English Input"
            ;;
    esac

    notify-send -i "$icon" -t 1500 "Input Method" "$message"
}

# Initialize cache file if it doesn't exist
if [ ! -f "$CACHE_FILE" ]; then
    echo "keyboard-us" > "$CACHE_FILE"
fi

# Main monitoring loop
while true; do
    CURRENT_IM=$(get_current_im)
    CACHED_IM=$(cat "$CACHE_FILE" 2>/dev/null || echo "keyboard-us")

    if [ "$CURRENT_IM" != "$CACHED_IM" ]; then
        echo "$CURRENT_IM" > "$CACHE_FILE"
        send_notification "$CURRENT_IM"
    fi

    sleep 0.5
done
