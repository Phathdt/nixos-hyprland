#!/usr/bin/env bash

LOCK_FILE="/tmp/wifi-popup-open"

if [[ -f "$LOCK_FILE" ]]; then
    # Window is open, close it
    eww close wifi-popup-window
    rm -f "$LOCK_FILE"
else
    # Window is closed, open it
    eww open wifi-popup-window
    touch "$LOCK_FILE"
fi
