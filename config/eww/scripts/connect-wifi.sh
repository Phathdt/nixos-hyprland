#!/usr/bin/env bash

ssid="$1"

if [[ -z "$ssid" ]]; then
    exit 1
fi

# Check if already connected
current=$(nmcli -t -f NAME connection show --active | grep -v '^lo$' | head -1)
if [[ "$current" == "$ssid" ]]; then
    exit 0
fi

# Try to connect
if nmcli connection show "$ssid" >/dev/null 2>&1; then
    # Connection exists, just activate it
    nmcli connection up "$ssid"
else
    # New connection, need password
    password=$(rofi -dmenu -p "Password for $ssid:" -password)
    if [[ -n "$password" ]]; then
        nmcli device wifi connect "$ssid" password "$password"
    fi
fi

# Close popup after connection attempt
eww close wifi-popup-window
rm -f "/tmp/wifi-popup-open"
