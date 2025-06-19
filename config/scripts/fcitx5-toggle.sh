#!/usr/bin/env bash

get_current_im() {
    ~/.config/scripts/fcitx5-fallback.sh -n 2>/dev/null || echo "keyboard-us"
}

toggle_input_method() {
    local current_im=$(get_current_im)

    case "$current_im" in
        "unikey")
            # Switch to English
            ~/.config/scripts/fcitx5-fallback.sh -s keyboard-us
            notify-send -i "input-keyboard" -t 1500 "Input Method" "🇺🇸 English Input"
            ;;
        "keyboard-us"|*)
            # Switch to Vietnamese
            ~/.config/scripts/fcitx5-fallback.sh -s unikey
            notify-send -i "input-keyboard" -t 1500 "Input Method" "🇻🇳 Vietnamese Input (Unikey)"
            ;;
    esac
}

# Main execution
toggle_input_method
