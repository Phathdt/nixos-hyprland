#!/usr/bin/env bash

toggle_vpn() {
    local current_status=$(~/.config/eww/scripts/get-vpn-status.sh)
    local enabled=$(echo "$current_status" | jq -r '.enabled')
    local vpn_type=$(echo "$current_status" | jq -r '.type')

    if [[ "$enabled" == "true" ]]; then
        case "$vpn_type" in
            "Tailscale")
                tailscale down
                notify-send "VPN" "Tailscale disconnected" -i network-vpn
                ;;
            "OpenVPN")
                nmcli connection down $(nmcli connection show --active | grep -E "vpn|tun|tap" | head -1 | awk '{print $1}')
                notify-send "VPN" "OpenVPN disconnected" -i network-vpn
                ;;
        esac
    else
        if command -v tailscale >/dev/null 2>&1; then
            tailscale up --accept-routes --accept-dns
            notify-send "VPN" "Tailscale connecting..." -i network-vpn
        else
            vpn_connections=$(nmcli connection show | grep vpn | head -1 | awk '{print $1}')
            if [[ -n "$vpn_connections" ]]; then
                nmcli connection up "$vpn_connections"
                notify-send "VPN" "Connecting to $vpn_connections..." -i network-vpn
            else
                notify-send "VPN" "No VPN connections configured" -i dialog-error
            fi
        fi
    fi
}

toggle_vpn
