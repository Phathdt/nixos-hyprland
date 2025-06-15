#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Function to get real icon name for application class
get_app_icon() {
    local class="$1"
    case "${class,,}" in
        # Browsers
        "brave-browser"|"brave") echo "brave-browser" ;;
        "google-chrome"|"chrome") echo "google-chrome" ;;
        "firefox") echo "firefox" ;;

        # Terminals
        "alacritty") echo "Alacritty" ;;
        "kitty") echo "kitty" ;;
        "wezterm") echo "org.wezfurlong.wezterm" ;;
        "foot") echo "foot" ;;

        # File managers
        "thunar") echo "thunar" ;;
        "nautilus") echo "org.gnome.Nautilus" ;;
        "pcmanfm") echo "pcmanfm" ;;

        # Text editors
        "code"|"vscode") echo "visual-studio-code" ;;
        "neovim"|"nvim") echo "nvim" ;;
        "vim") echo "vim" ;;

        # Communication
        "telegram-desktop"|"telegram") echo "telegram" ;;
        "discord") echo "discord" ;;
        "slack") echo "slack" ;;

        # Media
        "vlc") echo "vlc" ;;
        "mpv") echo "mpv" ;;
        "spotify") echo "spotify" ;;

        # System
        "pavucontrol") echo "pavucontrol" ;;
        "blueman-manager") echo "blueman" ;;
        "nm-connection-editor") echo "nm-connection-editor" ;;

        # Development
        "docker") echo "docker" ;;
        "postman") echo "postman" ;;

        # Default fallbacks
        *) echo "application-x-executable" ;;
    esac
}

# Get window list with workspace info and icons
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true and .workspace.id > 0) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Clean up title (remove newlines and limit length)
        clean_title=$(echo "$title" | tr -d '\n\r' | cut -c1-45)

        # Get application icon
        app_icon=$(get_app_icon "$class")

        # Add indicators for special states
        indicators=""
        [ "$floating" = "true" ] && indicators="${indicators} [Float]"
        [ "$fullscreen" = "true" ] && indicators="${indicators} [Full]"

        # Format for rofi with icon metadata
        printf "%s\x00icon\x1f%s\x1finfo\x1f%s\n" "[WS$workspace] $class: $clean_title$indicators" "$app_icon" "$address"
    done
}

# Show window menu with real icons
selected=$(get_windows | rofi -dmenu -i -p "󰖯 Switch Window" \
    -show-icons \
    -icon-theme "Papirus-Dark" \
    -theme-str 'window {width: 800px; height: 500px;}' \
    -theme-str 'listview {lines: 15;}' \
    -theme-str 'element-text {font: "JetBrainsMono Nerd Font 11";}' \
    -theme-str 'prompt {font: "JetBrainsMono Nerd Font Bold 12";}' \
    -theme-str 'element-icon {size: 24px; margin: 0px 8px 0px 0px;}' \
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

        # Focus the window using the most reliable method
        hyprctl dispatch focuswindow "address:$address" 2>/dev/null || \
        hyprctl dispatch focuswindow "pid:$pid" 2>/dev/null || \
        hyprctl dispatch focuswindow "$class" 2>/dev/null
    fi
fi
