#!/bin/bash

get_current_im() {
    fcitx5-remote -n 2>/dev/null || echo "keyboard-us"
}

format_output() {
    local im_name="$1"

    case "$im_name" in
        "unikey")
            echo "🇻🇳 VI"
            ;;
        "keyboard-us"|*)
            echo "🇺🇸 EN"
            ;;
    esac
}

CURRENT_IM=$(get_current_im)
format_output "$CURRENT_IM"
