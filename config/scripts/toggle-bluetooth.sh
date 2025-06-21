#!/usr/bin/env bash

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Bluetooth disabled" -i bluetooth-disabled
    echo "disabled"
else
    bluetoothctl power on
    notify-send "Bluetooth" "Bluetooth enabled" -i bluetooth
    echo "enabled"
fi
