#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Get available WiFi networks
get_wifi_networks() {
    nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | sort -t: -k2 -nr | while IFS=: read -r ssid signal security; do
        if [ -n "$ssid" ]; then
            # Format: SSID (Signal%) [Security]
            if [ -n "$security" ]; then
                echo "$ssid ($signal%) 🔒"
            else
                echo "$ssid ($signal%) 📶"
            fi
        fi
    done
}

# Get current connection
get_current_wifi() {
    nmcli -t -f NAME connection show --active | grep -v "lo\|docker\|br-"
}

# Show WiFi menu
show_menu() {
    local current_wifi=$(get_current_wifi)

    # Create menu options
    {
        if [ -n "$current_wifi" ]; then
            echo "🔌 Disconnect from $current_wifi"
        fi
        echo "🔄 Refresh Networks"
        echo "⚙️ Network Settings"
        echo "---"
        get_wifi_networks
    } | rofi -dmenu -i -p "WiFi Networks" \
        -theme-str 'window {width: 400px; height: 500px;}' \
        -theme-str 'listview {lines: 15;}' \
        -auto-select \
        -no-lazy-grab \
        -format 's' | {

        read -r selection

        case "$selection" in
            "🔌 Disconnect from"*)
                # Disconnect current WiFi
                nmcli connection down "$current_wifi"
                notify-send -a "NetworkManager" "WiFi" "Disconnected from $current_wifi"
                ;;
            "🔄 Refresh Networks")
                # Refresh and show menu again
                nmcli device wifi rescan
                sleep 2
                exec "$0"
                ;;
            "⚙️ Network Settings")
                # Open network settings
                nm-connection-editor &
                ;;
            *"🔒"|*"📶")
                # Connect to selected network
                ssid=$(echo "$selection" | sed 's/ ([0-9]*%) .*//')

                # Check if network requires password
                if echo "$selection" | grep -q "🔒"; then
                    # Secure network - prompt for password
                    password=$(rofi -dmenu -password -p "Password for $ssid" \
                        -theme-str 'window {width: 300px;}' \
                        -no-lazy-grab)
                    if [ -n "$password" ]; then
                        # Show connecting notification
                        notify-send -a "NetworkManager" "WiFi" "Connecting to $ssid..."
                        if nmcli device wifi connect "$ssid" password "$password"; then
                            notify-send -a "NetworkManager" "WiFi Connected" "Successfully connected to $ssid"
                        else
                            notify-send -a "NetworkManager" "WiFi Error" "Failed to connect to $ssid"
                        fi
                    fi
                else
                    # Open network
                    notify-send -a "NetworkManager" "WiFi" "Connecting to $ssid..."
                    if nmcli device wifi connect "$ssid"; then
                        notify-send -a "NetworkManager" "WiFi Connected" "Successfully connected to $ssid"
                    else
                        notify-send -a "NetworkManager" "WiFi Error" "Failed to connect to $ssid"
                    fi
                fi
                ;;
        esac
    }
}

show_menu
