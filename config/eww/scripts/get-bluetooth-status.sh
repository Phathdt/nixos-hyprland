#!/usr/bin/env bash

bluetooth_enabled=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$bluetooth_enabled" = "yes" ]; then
    connected_devices=$(bluetoothctl devices Connected | wc -l)
    if [ "$connected_devices" -gt 0 ]; then
        echo "{\"enabled\": true, \"class\": \"enabled\", \"icon\": \"󰂱\", \"text\": \"$connected_devices device(s)\", \"count\": \"$connected_devices\"}"
    else
        echo "{\"enabled\": true, \"class\": \"enabled\", \"icon\": \"󰂯\", \"text\": \"No devices\", \"count\": \"0\"}"
    fi
else
    echo "{\"enabled\": false, \"class\": \"disabled\", \"icon\": \"󰂲\", \"text\": \"Bluetooth disabled\", \"count\": \"0\"}"
fi
