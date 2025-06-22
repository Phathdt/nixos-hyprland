#!/usr/bin/env bash

wifi_enabled=$(nmcli radio wifi)
if [ "$wifi_enabled" = "enabled" ]; then
    connected_network=$(nmcli -t -f NAME connection show --active | grep -v lo | head -1)
    if [ -n "$connected_network" ]; then
        signal_strength=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '\*' | cut -d: -f2)
        echo "{\"enabled\": true, \"class\": \"enabled\", \"icon\": \"󰤨\", \"text\": \"$connected_network\", \"signal\": \"$signal_strength\"}"
    else
        echo "{\"enabled\": true, \"class\": \"enabled\", \"icon\": \"󰤨\", \"text\": \"Not connected\", \"signal\": \"0\"}"
    fi
else
    echo "{\"enabled\": false, \"class\": \"disabled\", \"icon\": \"󰤮\", \"text\": \"Wi-Fi disabled\", \"signal\": \"0\"}"
fi
