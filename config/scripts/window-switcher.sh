#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Function to get icon for application class
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

# Get window list with workspace info and icons
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true and .workspace.id > 0) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Clean up title (remove newlines and limit length)
        clean_title=$(echo "$title" | tr -d '\n\r' | cut -c1-45)

        # Get application icon
        app_icon=$(get_app_icon "$class")

        # Add indicators for special states
        indicators=""
        [ "$floating" = "true" ] && indicators="${indicators} 🪟"
        [ "$fullscreen" = "true" ] && indicators="${indicators} ⛶"

        # Format: [Icon] [WS] Class: Title [indicators]
        printf "%s [WS%s] %s: %s%s|%s\n" "$app_icon" "$workspace" "$class" "$clean_title" "$indicators" "$address"
    done
}

# Show window menu with enhanced styling
selected=$(get_windows | rofi -dmenu -i -p "󰖯 Switch Window" \
    -theme-str 'window {width: 700px; height: 450px;}' \
    -theme-str 'listview {lines: 15;}' \
    -theme-str 'element-text {font: "JetBrainsMono Nerd Font 11";}' \
    -theme-str 'prompt {font: "JetBrainsMono Nerd Font Bold 12";}' \
    -auto-select \
    -no-lazy-grab \
    -format 's')

if [ -n "$selected" ]; then
    # Extract window address
    address=$(echo "$selected" | cut -d'|' -f2)

    if [ -n "$address" ]; then
        # Get window info for better handling
        window_info=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | \"\(.pid)|\(.class)|\(.floating)|\(.fullscreen)|\(.workspace.id)\"" 2>/dev/null)

        if [ -n "$window_info" ]; then
            IFS='|' read -r pid class floating fullscreen workspace <<< "$window_info"

            # Handle special cases
            if [ "$floating" = "true" ]; then
                # For floating windows, try to bring to front first
                hyprctl dispatch bringactivetotop 2>/dev/null
            fi

            if [ "$fullscreen" = "true" ]; then
                # For fullscreen windows, exit fullscreen first then focus
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

        # Try multiple methods to focus the window

        # Method 1: Focus by address
        if hyprctl dispatch focuswindow "address:$address" 2>/dev/null; then
            exit 0
        fi

        # Method 2: Focus by PID (fallback for some applications)
        if [ -n "$pid" ] && [ "$pid" != "null" ]; then
            if hyprctl dispatch focuswindow "pid:$pid" 2>/dev/null; then
                exit 0
            fi
        fi

        # Method 3: Focus by class (last resort)
        if [ -n "$class" ] && [ "$class" != "null" ]; then
            hyprctl dispatch focuswindow "$class" 2>/dev/null
        fi
    fi
fi
