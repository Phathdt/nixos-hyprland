#!/usr/bin/env bash

status=$(nmcli radio wifi)
if [ "$status" = "enabled" ]; then
    echo '{"text": "󰖩 Wi-Fi", "class": "wifi-enabled", "tooltip": "WiFi is enabled"}'
else
    echo '{"text": "󰖩 Wi-Fi", "class": "wifi-disabled", "tooltip": "WiFi is disabled"}'
fi
