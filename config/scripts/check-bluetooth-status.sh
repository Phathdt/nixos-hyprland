#!/usr/bin/env bash

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
    echo '{"text": "󰂯 Bluetooth", "class": "bluetooth-enabled", "tooltip": "Bluetooth is enabled"}'
else
    echo '{"text": "󰂯 Bluetooth", "class": "bluetooth-disabled", "tooltip": "Bluetooth is disabled"}'
fi
