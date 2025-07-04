#!/usr/bin/env bash

status=$(nmcli radio wifi)
if [ "$status" = "enabled" ]; then
    nmcli radio wifi off
    notify-send "WiFi" "WiFi disabled" -i network-wireless-offline
    echo "disabled"
else
    nmcli radio wifi on
    notify-send "WiFi" "WiFi enabled" -i network-wireless
    echo "enabled"
fi
