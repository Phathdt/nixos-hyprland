#!/usr/bin/env bash

# Bluetooth Module for Waybar
# Shows Bluetooth status and allows device selection

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to get Bluetooth status
get_bluetooth_status() {
    if ! command -v bluetoothctl >/dev/null 2>&1; then
        echo '{"text": "󰂲", "tooltip": "Bluetooth not available", "class": "disabled"}'
        return
    fi

    # Check if Bluetooth is powered on
    if bluetoothctl show | grep -q "Powered: yes"; then
        # Check for connected devices
        connected_devices=$(bluetoothctl devices Connected | wc -l)
        if [ "$connected_devices" -gt 0 ]; then
            # Get first connected device name
            device_name=$(bluetoothctl devices Connected | head -1 | cut -d' ' -f3-)
            if [ -n "$device_name" ]; then
                echo "{\"text\": \"󰂱 $device_name\", \"tooltip\": \"Connected to $device_name\", \"class\": \"connected\"}"
            else
                echo '{"text": "󰂯", "tooltip": "Bluetooth: On (No devices connected)", "class": "on"}'
            fi
        else
            echo '{"text": "󰂯", "tooltip": "Bluetooth: On (No devices connected)", "class": "on"}'
        fi
    else
        echo '{"text": "󰂲", "tooltip": "Bluetooth: Off", "class": "off"}'
    fi
}

# Function to get Bluetooth tooltip
get_bluetooth_tooltip() {
    if ! command -v bluetoothctl >/dev/null 2>&1; then
        echo "Bluetooth not available"
        return
    fi

    # Check if Bluetooth is powered on
    if bluetoothctl show | grep -q "Powered: yes"; then
        # Get connected devices
        connected_devices=$(bluetoothctl devices Connected)
        if [ -n "$connected_devices" ]; then
            echo "Connected Devices:"
            echo "$connected_devices" | while read -r line; do
                mac=$(echo "$line" | cut -d' ' -f2)
                name=$(echo "$line" | cut -d' ' -f3-)
                echo "  • $name ($mac)"
            done
        else
            echo "Bluetooth: On (No devices connected)"
        fi
    else
        echo "Bluetooth: Off"
    fi
}

# Function to handle clicks
handle_click() {
    case "$1" in
        "left")
            # Open Blueman manager
            blueman-manager &
            ;;
        "middle")
            # Show quick device menu
            show_device_menu
            ;;
    esac
}

# Function to show device menu
show_device_menu() {
    if ! command -v bluetoothctl >/dev/null 2>&1; then
        notify-send "Bluetooth" "Bluetooth tools not available"
        return
    fi

    # Get paired devices
    paired_devices=$(bluetoothctl paired-devices)

    if [ -z "$paired_devices" ]; then
        notify-send "Bluetooth" "No paired devices found"
        return
    fi

    # Create menu options
    menu_items=""
    while IFS= read -r line; do
        mac=$(echo "$line" | cut -d' ' -f2)
        name=$(echo "$line" | cut -d' ' -f3-)
        status=""

        # Check if device is connected
        if bluetoothctl devices Connected | grep -q "$mac"; then
            status=" (Connected)"
        fi

        menu_items="$menu_items$name$status\n"
    done <<< "$paired_devices"

    # Add scan option
    menu_items="${menu_items}Scan for new devices\n"
    menu_items="${menu_items}Toggle Bluetooth"

    # Show menu using rofi
    if command -v rofi >/dev/null 2>&1; then
        selected=$(echo -e "$menu_items" | rofi -dmenu -p "Bluetooth Devices" -theme ~/.config/rofi/themes/material.rasi)

        if [ -n "$selected" ]; then
            case "$selected" in
                "Scan for new devices")
                    bluetoothctl scan on &
                    notify-send "Bluetooth" "Scanning for devices..."
                    ;;
                "Toggle Bluetooth")
                    if bluetoothctl show | grep -q "Powered: yes"; then
                        bluetoothctl power off
                        notify-send "Bluetooth" "Bluetooth turned off"
                    else
                        bluetoothctl power on
                        notify-send "Bluetooth" "Bluetooth turned on"
                    fi
                    ;;
                *)
                    # Find device MAC address
                    mac=$(echo "$paired_devices" | grep "$selected" | cut -d' ' -f2)
                    if [ -n "$mac" ]; then
                        if bluetoothctl devices Connected | grep -q "$mac"; then
                            bluetoothctl disconnect "$mac"
                            notify-send "Bluetooth" "Disconnected from $selected"
                        else
                            bluetoothctl connect "$mac"
                            notify-send "Bluetooth" "Connecting to $selected..."
                        fi
                    fi
                    ;;
            esac
        fi
    else
        notify-send "Bluetooth" "Rofi not available for device menu"
    fi
}

# Main script logic
case "$1" in
    "status")
        get_bluetooth_status
        ;;
    "tooltip")
        get_bluetooth_tooltip
        ;;
    "click")
        handle_click "$2"
        ;;
    *)
        echo "Usage: $0 {status|tooltip|click <button>}"
        exit 1
        ;;
esac
