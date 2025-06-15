#!/bin/bash

pkill rofi

show_settings_menu() {
    local options="🖥️ Display Settings|display|
🔊 Audio Settings|audio|
🌐 Network Settings|network|
🔵 Bluetooth Settings|bluetooth|
⚡ Power Management|power|
🎨 Appearance|appearance|
📁 File Manager|files|
⚙️ System Monitor|monitor|
🔧 Hyprland Config|hyprland|
📋 Waybar Config|waybar|
🎯 Rofi Themes|rofi|
🖼️ Wallpaper Manager|wallpaper|
🔔 Notification Settings|notifications|
📊 System Info|sysinfo|
🔄 Reload Configs|reload|
---
💻 NixOS Configuration|nixos|
🔧 Hardware Info|hardware|
📦 Package Manager|packages|"

    echo -e "$options" | rofi -dmenu \
        -i \
        -p "Settings" \
        -theme ~/.config/rofi/settings-menu.rasi \
        -auto-select \
        -no-lazy-grab \
        -format "s" \
        -sep "|" \
        -selected-row 0
}

handle_action() {
    local selection="$1"
    local action=$(echo "$selection" | cut -d'|' -f2)

    case "$action" in
        "display")
            wdisplays &
            ;;
        "audio")
            pavucontrol &
            ;;
        "network")
            nm-connection-editor &
            ;;
        "bluetooth")
            blueman-manager &
            ;;
        "power")
            xfce4-power-manager-settings &
            ;;
        "appearance")
            lxappearance &
            ;;
        "files")
            thunar &
            ;;
        "monitor")
            htop &
            ;;
        "hyprland")
            code ~/.config/hypr/ &
            ;;
        "waybar")
            code ~/.config/waybar/ &
            ;;
        "rofi")
            code ~/.config/rofi/ &
            ;;
        "wallpaper")
            ~/.config/scripts/wallpaper-menu.sh
            ;;
        "notifications")
            code ~/.config/dunst/dunstrc &
            ;;
        "sysinfo")
            kitty -e neofetch &
            ;;
        "reload")
            show_reload_menu
            ;;
        "nixos")
            code ~/nixos-hyprland/ &
            ;;
        "hardware")
            kitty -e lshw -short &
            ;;
        "packages")
            kitty -e nix search nixpkgs &
            ;;
    esac
}

show_reload_menu() {
    local options="🔄 Reload Waybar|waybar|
🔄 Reload Hyprland|hyprland|
🔄 Reload Dunst|dunst|
🔄 Restart Audio|audio|
🔄 Reload All|all|"

    local selection=$(echo -e "$options" | rofi -dmenu \
        -i \
        -p "Reload Configuration" \
        -theme ~/.config/rofi/settings-menu.rasi \
        -auto-select \
        -no-lazy-grab \
        -format "s" \
        -sep "|")

    if [ -n "$selection" ]; then
        local reload_action=$(echo "$selection" | cut -d'|' -f2)
        case "$reload_action" in
            "waybar")
                pkill waybar && waybar &
                notify-send "Settings" "Waybar reloaded" -i preferences-system
                ;;
            "hyprland")
                hyprctl reload
                notify-send "Settings" "Hyprland configuration reloaded" -i preferences-system
                ;;
            "dunst")
                pkill dunst && dunst &
                notify-send "Settings" "Dunst reloaded" -i preferences-system
                ;;
            "audio")
                systemctl --user restart pipewire pipewire-pulse
                notify-send "Settings" "Audio system restarted" -i preferences-system
                ;;
            "all")
                pkill waybar && waybar &
                hyprctl reload
                pkill dunst && dunst &
                notify-send "Settings" "All configurations reloaded" -i preferences-system
                ;;
        esac
    fi
}

main() {
    local selection=$(show_settings_menu)
    if [ -n "$selection" ]; then
        handle_action "$selection"
    fi
}

main
