#!/usr/bin/env bash

get_vpn_status() {
    local vpn_active=false
    local vpn_type=""
    local vpn_name=""

    # Check for real VPN connections (OpenVPN, WireGuard, L2TP, etc.)
    if nmcli connection show --active | grep -q "vpn"; then
        vpn_active=true
        vpn_type="VPN"
        vpn_name=$(nmcli connection show --active | grep "vpn" | head -1 | awk '{print $1}')
    elif nmcli connection show --active | grep -q "wireguard"; then
        vpn_active=true
        vpn_type="WireGuard"
        vpn_name=$(nmcli connection show --active | grep "wireguard" | head -1 | awk '{print $1}')
    elif ip route | grep -q "tun0\|wg0"; then
        vpn_active=true
        vpn_type="VPN"
        vpn_name="VPN Connection"
    fi

    if $vpn_active; then
        echo "{\"enabled\": true, \"type\": \"$vpn_type\", \"name\": \"$vpn_name\", \"icon\": \"󰖂\", \"class\": \"connected\"}"
    else
        echo "{\"enabled\": false, \"type\": \"\", \"name\": \"Disconnected\", \"icon\": \"󰖂\", \"class\": \"disconnected\"}"
    fi
}

case "$1" in
    "waybar")
        vpn_info=$(get_vpn_status)
        enabled=$(echo "$vpn_info" | jq -r '.enabled')
        icon=$(echo "$vpn_info" | jq -r '.icon')
        name=$(echo "$vpn_info" | jq -r '.name')

        if [[ "$enabled" == "true" ]]; then
            echo "{\"text\": \"$icon\", \"tooltip\": \"VPN Connected: $name\", \"class\": \"connected\"}"
        else
            echo "{\"text\": \"󰖂\", \"tooltip\": \"VPN Disconnected\", \"class\": \"disconnected\"}"
        fi
        ;;
    "eww"|*)
        get_vpn_status
        ;;
esac
