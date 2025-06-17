#!/usr/bin/env bash

# Modern WiFi Menu with Rofi
# Inspired by modern widget designs

# Colors (Material Palenight)
BG="#292D3E"
FG="#EEFFFF"
ACCENT="#C792EA"
ACCENT_ALT="#82AAFF"
SELECTED="#3A3F58"

# Get WiFi status
wifi_status=$(nmcli radio wifi)
current_network=$(nmcli -t -f NAME connection show --active | grep -v '^lo$' | head -1)

# Create header
if [[ "$wifi_status" == "enabled" ]]; then
    header="󰤨  WiFi: ON"
    if [[ -n "$current_network" ]]; then
        header="$header  Connected to: $current_network"
    fi
else
    header="󰤭  WiFi: OFF"
fi

# Menu options
options=()

# Add WiFi toggle
if [[ "$wifi_status" == "enabled" ]]; then
    options+=("󰤭  Turn WiFi OFF")
else
    options+=("󰤨  Turn WiFi ON")
fi

# Add separator
options+=("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

# Add available networks if WiFi is on
if [[ "$wifi_status" == "enabled" ]]; then
    options+=("🔄  Refresh Networks")
    options+=("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    # Get networks
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

        # Signal strength icon
        if [[ $signal -gt 75 ]]; then
            signal_icon="󰤨"
        elif [[ $signal -gt 50 ]]; then
            signal_icon="󰤥"
        elif [[ $signal -gt 25 ]]; then
            signal_icon="󰤢"
        else
            signal_icon="󰤟"
        fi

        # Security icon
        if [[ "$security" == *"WPA"* ]] || [[ "$security" == *"WEP"* ]]; then
            security_icon="🔒"
        else
            security_icon="🔓"
        fi

        # Connected indicator
        if [[ "$ssid" == "$current_network" ]]; then
            options+=("✅ $signal_icon  $ssid  $signal%  $security_icon  [CONNECTED]")
        else
            options+=("$signal_icon  $ssid  $signal%  $security_icon")
        fi

    done <<< "$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2)"
fi

# Add settings option
options+=("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
options+=("⚙️   WiFi Settings")

# Show rofi menu
selected=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "$header" -theme ~/.config/rofi/themes/wifi-menu.rasi)

# Handle selection
case "$selected" in
    "󰤭  Turn WiFi OFF")
        nmcli radio wifi off
        notify-send "WiFi" "WiFi turned OFF" -i network-wireless-offline
        ;;
    "󰤨  Turn WiFi ON")
        nmcli radio wifi on
        notify-send "WiFi" "WiFi turned ON" -i network-wireless
        ;;
    "🔄  Refresh Networks")
        nmcli device wifi rescan
        sleep 2
        exec "$0"
        ;;
    "⚙️   WiFi Settings")
        nm-connection-editor
        ;;
    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        # Separator, do nothing
        ;;
    *)
        if [[ -n "$selected" && "$selected" != *"━━━"* ]]; then
            # Extract SSID from selection
            ssid=$(echo "$selected" | sed 's/^[✅🔒🔓󰤨󰤥󰤢󰤟]*[[:space:]]*//' | awk '{print $1}')

            if [[ -n "$ssid" ]]; then
                # Check if already connected
                if [[ "$selected" == *"[CONNECTED]"* ]]; then
                    # Disconnect
                    nmcli connection down "$ssid"
                    notify-send "WiFi" "Disconnected from $ssid" -i network-wireless-offline
                else
                    # Try to connect
                    if nmcli connection show "$ssid" >/dev/null 2>&1; then
                        # Connection exists, just activate
                        nmcli connection up "$ssid"
                        notify-send "WiFi" "Connected to $ssid" -i network-wireless
                    else
                        # New connection, need password
                        password=$(rofi -dmenu -password -p "Password for $ssid:" -theme ~/.config/rofi/themes/wifi-menu.rasi)
                        if [[ -n "$password" ]]; then
                            if nmcli device wifi connect "$ssid" password "$password"; then
                                notify-send "WiFi" "Connected to $ssid" -i network-wireless
                            else
                                notify-send "WiFi" "Failed to connect to $ssid" -i network-error
                            fi
                        fi
                    fi
                fi
            fi
        fi
        ;;
esac
