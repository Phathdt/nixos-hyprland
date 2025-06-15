#!/usr/bin/env bash

# Enhanced window switcher with proper application icons
# Uses desktop files and icon themes for better visual experience

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Function to get desktop file for application
get_desktop_file() {
    local class="$1"
    local search_paths=(
        "/usr/share/applications"
        "/usr/local/share/applications"
        "$HOME/.local/share/applications"
        "/var/lib/flatpak/exports/share/applications"
        "$HOME/.local/share/flatpak/exports/share/applications"
    )

    # Common mappings for class names to desktop files
    case "${class,,}" in
        "brave-browser"|"brave") echo "brave-browser.desktop" ;;
        "google-chrome"|"chrome") echo "google-chrome.desktop" ;;
        "firefox") echo "firefox.desktop" ;;
        "alacritty") echo "Alacritty.desktop" ;;
        "kitty") echo "kitty.desktop" ;;
        "thunar") echo "thunar.desktop" ;;
        "code"|"vscode") echo "code.desktop" ;;
        "telegram-desktop") echo "telegram-desktop.desktop" ;;
        "discord") echo "discord.desktop" ;;
        "vlc") echo "vlc.desktop" ;;
        "spotify") echo "spotify.desktop" ;;
        "pavucontrol") echo "pavucontrol.desktop" ;;
        *)
            # Try to find desktop file by searching
            for path in "${search_paths[@]}"; do
                if [ -d "$path" ]; then
                    # Try exact match first
                    if [ -f "$path/${class,,}.desktop" ]; then
                        echo "${class,,}.desktop"
                        return
                    fi
                    # Try case-insensitive search
                    found=$(find "$path" -maxdepth 1 -iname "*${class}*.desktop" -type f | head -1)
                    if [ -n "$found" ]; then
                        basename "$found"
                        return
                    fi
                fi
            done
            echo ""
            ;;
    esac
}

# Function to get icon from desktop file
get_app_icon() {
    local class="$1"
    local desktop_file=$(get_desktop_file "$class")

    if [ -n "$desktop_file" ]; then
        # Search for the desktop file
        for path in "/usr/share/applications" "/usr/local/share/applications" "$HOME/.local/share/applications"; do
            if [ -f "$path/$desktop_file" ]; then
                # Extract icon from desktop file
                icon=$(grep "^Icon=" "$path/$desktop_file" | cut -d'=' -f2 | head -1)
                if [ -n "$icon" ]; then
                    echo "$icon"
                    return
                fi
            fi
        done
    fi

    # Fallback to emoji icons
    case "${class,,}" in
        "brave-browser"|"brave"|"google-chrome"|"chrome"|"firefox") echo "web-browser" ;;
        "alacritty"|"kitty"|"wezterm"|"foot") echo "terminal" ;;
        "thunar"|"nautilus"|"pcmanfm") echo "folder" ;;
        "code"|"vscode"|"neovim"|"nvim"|"vim") echo "text-editor" ;;
        "telegram-desktop"|"telegram"|"discord"|"slack") echo "internet-chat" ;;
        "vlc"|"mpv") echo "video-player" ;;
        "spotify") echo "audio-player" ;;
        "pavucontrol") echo "audio-volume-high" ;;
        "blueman-manager") echo "bluetooth" ;;
        "nm-connection-editor") echo "network-wired" ;;
        "docker") echo "application-x-docker" ;;
        *) echo "application-x-executable" ;;
    esac
}

# Get window list with workspace info and icons
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true and .workspace.id > 0) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Clean up title (remove newlines and limit length)
        clean_title=$(echo "$title" | tr -d '\n\r' | cut -c1-40)

        # Get application icon
        app_icon=$(get_app_icon "$class")

        # Add indicators for special states
        indicators=""
        [ "$floating" = "true" ] && indicators="${indicators} "
        [ "$fullscreen" = "true" ] && indicators="${indicators} "

        # Format for rofi with icon
        printf "%s\x00icon\x1f%s\x1finfo\x1f%s\n" "[WS$workspace] $class: $clean_title$indicators" "$app_icon" "$address"
    done
}

# Show window menu with icons
selected=$(get_windows | rofi -dmenu -i -p "󰖯 Switch Window" \
    -show-icons \
    -icon-theme "Papirus-Dark" \
    -theme-str 'window {width: 800px; height: 500px;}' \
    -theme-str 'listview {lines: 15;}' \
    -theme-str 'element-text {font: "JetBrainsMono Nerd Font 11";}' \
    -theme-str 'prompt {font: "JetBrainsMono Nerd Font Bold 12";}' \
    -theme-str 'element-icon {size: 24px;}' \
    -auto-select \
    -no-lazy-grab \
    -format 'i')

if [ -n "$selected" ]; then
    # Extract window address from info field
    address="$selected"

    if [ -n "$address" ]; then
        # Get window info for better handling
        window_info=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | \"\(.pid)|\(.class)|\(.floating)|\(.fullscreen)|\(.workspace.id)\"" 2>/dev/null)

        if [ -n "$window_info" ]; then
            IFS='|' read -r pid class floating fullscreen workspace <<< "$window_info"

            # Handle special cases
            if [ "$floating" = "true" ]; then
                hyprctl dispatch bringactivetotop 2>/dev/null
            fi

            if [ "$fullscreen" = "true" ]; then
                hyprctl dispatch fullscreen 0 2>/dev/null
                sleep 0.1
            fi

            # Switch to workspace first if different
            current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id' 2>/dev/null)
            if [ "$workspace" != "$current_workspace" ]; then
                hyprctl dispatch workspace "$workspace" 2>/dev/null
                sleep 0.1
            fi
        fi

        # Focus the window
        hyprctl dispatch focuswindow "address:$address" 2>/dev/null || \
        hyprctl dispatch focuswindow "pid:$pid" 2>/dev/null || \
        hyprctl dispatch focuswindow "$class" 2>/dev/null
    fi
fi
