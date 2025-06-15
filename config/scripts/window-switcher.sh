#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Function to get emoji icon for application class
get_app_icon() {
    local class="$1"
    case "${class,,}" in
        # Browsers
        "brave-browser"|"brave") echo "🌐" ;;
        "google-chrome"|"chrome") echo "🌐" ;;
        "firefox") echo "🦊" ;;

        # Terminals
        "alacritty") echo "💻" ;;
        "kitty") echo "🐱" ;;
        "wezterm") echo "💻" ;;
        "foot") echo "💻" ;;

        # File managers
        "thunar") echo "📁" ;;
        "nautilus") echo "📁" ;;
        "pcmanfm") echo "📁" ;;

        # Text editors
        "code"|"vscode") echo "📝" ;;
        "neovim"|"nvim") echo "✏️" ;;
        "vim") echo "✏️" ;;

        # Communication
        "telegram-desktop"|"telegram") echo "💬" ;;
        "discord") echo "🎮" ;;
        "slack") echo "💼" ;;

        # Media
        "vlc") echo "🎬" ;;
        "mpv") echo "🎬" ;;
        "spotify") echo "🎵" ;;

        # System
        "pavucontrol") echo "🔊" ;;
        "blueman-manager") echo "📶" ;;
        "nm-connection-editor") echo "🌐" ;;

        # Development
        "docker") echo "🐳" ;;
        "postman") echo "📮" ;;

        # Default
        *) echo "🪟" ;;
    esac
}

# Get window list and create simple menu
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true and .workspace.id > 0) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Clean up title
        clean_title=$(echo "$title" | tr -d '\n\r' | cut -c1-45)

        # Get app icon
        app_icon=$(get_app_icon "$class")

        # Add indicators
        indicators=""
        [ "$floating" = "true" ] && indicators="${indicators} 🪟"
        [ "$fullscreen" = "true" ] && indicators="${indicators} ⛶"

        # Format with icon: [Icon] [WS] Class: Title [indicators]|address
        printf "%s [WS%s] %s: %s%s|%s\n" "$app_icon" "$workspace" "$class" "$clean_title" "$indicators" "$address"
    done
}

# Show window menu
selected=$(get_windows | rofi -dmenu -i -p "󰖯 Switch Window" \
    -theme-str 'window {width: 800px; height: 500px;}' \
    -theme-str 'listview {lines: 15;}' \
    -theme-str 'element-text {font: "JetBrainsMono Nerd Font 11";}' \
    -theme-str 'prompt {font: "JetBrainsMono Nerd Font Bold 12";}' \
    -auto-select \
    -no-lazy-grab)

if [ -n "$selected" ]; then
    # Extract window address
    address=$(echo "$selected" | cut -d'|' -f2)

    if [ -n "$address" ]; then
        # Get window info
        window_info=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | \"\(.workspace.id)|\(.floating)|\(.fullscreen)\"" 2>/dev/null)

        if [ -n "$window_info" ]; then
            IFS='|' read -r workspace floating fullscreen <<< "$window_info"

            # Switch workspace if needed
            current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id' 2>/dev/null)
            if [ "$workspace" != "$current_workspace" ]; then
                hyprctl dispatch workspace "$workspace" 2>/dev/null
                sleep 0.1
            fi

            # Handle fullscreen
            if [ "$fullscreen" = "true" ]; then
                hyprctl dispatch fullscreen 0 2>/dev/null
                sleep 0.1
            fi
        fi

        # Focus window
        hyprctl dispatch focuswindow "address:$address" 2>/dev/null
    fi
fi
