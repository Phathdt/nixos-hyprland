#!/usr/bin/env bash

toggle_vpn() {
    local current_status=$(~/.config/eww/scripts/get-vpn-status.sh)
    local enabled=$(echo "$current_status" | jq -r '.enabled')
    local vpn_name=$(echo "$current_status" | jq -r '.name')

    if [[ "$enabled" == "true" ]]; then
        # Disconnect active VPN
        if nmcli connection show --active | grep -q "vpn"; then
            active_vpn=$(nmcli connection show --active | grep "vpn" | head -1 | awk '{print $1}')
            nmcli connection down "$active_vpn"
            notify-send "VPN" "Disconnected from $active_vpn" -i network-vpn
        elif nmcli connection show --active | grep -q "wireguard"; then
            active_wg=$(nmcli connection show --active | grep "wireguard" | head -1 | awk '{print $1}')
            nmcli connection down "$active_wg"
            notify-send "VPN" "Disconnected from $active_wg" -i network-vpn
        else
            notify-send "VPN" "VPN disconnected" -i network-vpn
        fi
    else
        # Connect to available VPN
        vpn_connections=$(nmcli connection show | grep -E "vpn|wireguard" | head -1 | awk '{print $1}')
        if [[ -n "$vpn_connections" ]]; then
            nmcli connection up "$vpn_connections"
            notify-send "VPN" "Connecting to $vpn_connections..." -i network-vpn
        else
            notify-send "VPN" "No VPN connections configured\nPlease setup OpenVPN, WireGuard, or other VPN" -i dialog-error
        fi
    fi
}

toggle_vpn
