#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Determine which launcher to show based on argument
case "${1:-drun}" in
    "drun")
        rofi -show drun \
            -auto-select \
            -no-lazy-grab
        ;;
    "run")
        rofi -show run \
            -auto-select \
            -no-lazy-grab
        ;;
    *)
        echo "Usage: $0 [drun|run]"
        exit 1
        ;;
esac
