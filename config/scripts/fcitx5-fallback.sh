#!/usr/bin/env bash

# Check if fcitx5-remote is available
if command -v fcitx5-remote &> /dev/null; then
    echo "Using fcitx5-remote"
    exec fcitx5-remote "$@"
fi

# Check if dbus is available and try to control fcitx5 via dbus
if command -v dbus-send &> /dev/null; then
    echo "Trying dbus method..."

    case "$1" in
        "-t"|"--toggle")
            dbus-send --session --type=method_call \
                --dest=org.fcitx.Fcitx5 \
                /controller \
                org.fcitx.Fcitx.Controller1.Toggle
            ;;
        "-n"|"--current")
            # Try to get current input method via dbus
            dbus-send --session --print-reply \
                --dest=org.fcitx.Fcitx5 \
                /controller \
                org.fcitx.Fcitx.Controller1.CurrentInputMethod 2>/dev/null | \
                grep -o '".*"' | sed 's/"//g' || echo "keyboard-us"
            ;;
        "-s"|"--set")
            if [ -n "$2" ]; then
                dbus-send --session --type=method_call \
                    --dest=org.fcitx.Fcitx5 \
                    /controller \
                    org.fcitx.Fcitx.Controller1.SetCurrentInputMethod \
                    string:"$2"
            fi
            ;;
        "-l"|"--list")
            echo "keyboard-us"
            echo "unikey"
            ;;
        *)
            echo "Usage: $0 {-t|--toggle|-n|--current|-s|--set <method>|-l|--list}"
            ;;
    esac
else
    echo "Neither fcitx5-remote nor dbus-send is available"
    exit 1
fi
