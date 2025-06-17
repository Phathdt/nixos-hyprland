#!/bin/bash

# Get current connection
current_ssid=$(nmcli -t -f NAME connection show --active | grep -v '^lo$' | head -1)

# Get available networks
networks=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2)

echo "["
first=true
while IFS= read -r line; do
    if [[ -z "$line" || "$line" == *"--"* ]]; then
        continue
    fi

    ssid=$(echo "$line" | awk '{print $1}')
    signal=$(echo "$line" | awk '{print $2}')
    security=$(echo "$line" | awk '{$1=""; $2=""; print $0}' | xargs)

    if [[ -z "$ssid" || "$ssid" == "--" ]]; then
        continue
    fi

    # Determine connection status
    if [[ "$ssid" == "$current_ssid" ]]; then
        status="Connected"
        connected="true"
        icon="󰤨"
    else
        status=""
        connected="false"
        # Signal strength icon
        if [[ $signal -gt 75 ]]; then
            icon="󰤨"
        elif [[ $signal -gt 50 ]]; then
            icon="󰤥"
        elif [[ $signal -gt 25 ]]; then
            icon="󰤢"
        else
            icon="󰤟"
        fi
    fi

    # Security status
    if [[ "$security" == *"WPA"* ]] || [[ "$security" == *"WEP"* ]]; then
        security_icon="🔒"
    else
        security_icon=""
    fi

    if [[ "$first" == "false" ]]; then
        echo ","
    fi
    first=false

    echo "  {"
    echo "    \"ssid\": \"$ssid\","
    echo "    \"signal\": \"$signal%\","
    echo "    \"status\": \"$status\","
    echo "    \"connected\": $connected,"
    echo "    \"icon\": \"$icon\","
    echo "    \"security\": \"$security_icon\""
    echo -n "  }"

done <<< "$networks"

echo ""
echo "]"
