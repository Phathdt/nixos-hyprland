#!/usr/bin/env bash

get_vpn_status() {
    local tailscale_status=""
    local openvpn_status=""
    local vpn_active=false
    local vpn_type=""
    local vpn_name=""

    if command -v tailscale >/dev/null 2>&1; then
        tailscale_status=$(tailscale status --json 2>/dev/null | jq -r '.BackendState // "Stopped"')
        if [[ "$tailscale_status" == "Running" ]]; then
            vpn_active=true
            vpn_type="Tailscale"
            vpn_name="Tailscale"
        fi
    fi

    if ! $vpn_active; then
        if nmcli connection show --active | grep -q "vpn\|tun\|tap"; then
            vpn_active=true
            vpn_type="OpenVPN"
            vpn_name=$(nmcli connection show --active | grep -E "vpn|tun|tap" | head -1 | awk '{print $1}')
        fi
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
