#!/usr/bin/env bash

pkill rofi

get_bluetooth_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

get_connected_devices() {
    bluetoothctl devices Connected | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)
        echo "🔗 $name|disconnect|$mac"
    done
}

get_paired_devices() {
    bluetoothctl devices Paired | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)
        if ! bluetoothctl devices Connected | grep -q "$mac"; then
            echo "📱 $name|connect|$mac"
        fi
    done
}

get_discoverable_devices() {
    timeout 10 bluetoothctl scan on > /dev/null 2>&1 &
    sleep 3
    bluetoothctl devices | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)
        if ! bluetoothctl devices Paired | grep -q "$mac"; then
            echo "🔍 $name|pair|$mac"
        fi
    done
    bluetoothctl scan off > /dev/null 2>&1
}

show_bluetooth_menu() {
    local status=$(get_bluetooth_status)
    local options=""

    if [ "$status" = "off" ]; then
        options="🔵 Turn On Bluetooth|power_on|"
    else
        options="🔴 Turn Off Bluetooth|power_off|
📡 Scan for Devices|scan|
⚙️ Open Bluetooth Settings|settings|
---
$(get_connected_devices)
$(get_paired_devices)"
    fi

    echo -e "$options" | rofi -dmenu \
        -i \
        -p "Bluetooth" \
        -theme ~/.config/rofi/bluetooth-menu.rasi \
        -auto-select \
        -no-lazy-grab \
        -format "s" \
        -sep "|" \
        -selected-row 0
}

handle_action() {
    local selection="$1"
    local action=$(echo "$selection" | cut -d'|' -f2)
    local mac=$(echo "$selection" | cut -d'|' -f3)

    case "$action" in
        "power_on")
            bluetoothctl power on
            notify-send "Bluetooth" "Bluetooth turned on" -i bluetooth
            ;;
        "power_off")
            bluetoothctl power off
            notify-send "Bluetooth" "Bluetooth turned off" -i bluetooth
            ;;
        "connect")
            bluetoothctl connect "$mac"
            device_name=$(echo "$selection" | cut -d'|' -f1 | sed 's/📱 //')
            notify-send "Bluetooth" "Connecting to $device_name..." -i bluetooth
            ;;
        "disconnect")
            bluetoothctl disconnect "$mac"
            device_name=$(echo "$selection" | cut -d'|' -f1 | sed 's/🔗 //')
            notify-send "Bluetooth" "Disconnected from $device_name" -i bluetooth
            ;;
        "pair")
            device_name=$(echo "$selection" | cut -d'|' -f1 | sed 's/🔍 //')
            notify-send "Bluetooth" "Pairing with $device_name..." -i bluetooth
            bluetoothctl pair "$mac" && bluetoothctl connect "$mac"
            ;;
        "scan")
            notify-send "Bluetooth" "Scanning for devices..." -i bluetooth
            show_scan_menu
            ;;
        "settings")
            blueman-manager &
            ;;
    esac
}

show_scan_menu() {
    local devices=$(get_discoverable_devices)
    if [ -z "$devices" ]; then
        notify-send "Bluetooth" "No new devices found" -i bluetooth
        return
    fi

    local selection=$(echo -e "$devices" | rofi -dmenu \
        -i \
        -p "Available Devices" \
        -theme ~/.config/rofi/bluetooth-menu.rasi \
        -auto-select \
        -no-lazy-grab \
        -format "s")

    if [ -n "$selection" ]; then
        handle_action "$selection"
    fi
}

main() {
    local selection=$(show_bluetooth_menu)
    if [ -n "$selection" ]; then
        handle_action "$selection"
    fi
}

main
