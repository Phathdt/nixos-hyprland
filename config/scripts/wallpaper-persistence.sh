#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER_FILE="$HOME/.cache/current-wallpaper"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Function to save current wallpaper
save_current_wallpaper() {
    local wallpaper="$1"
    echo "$wallpaper" > "$CURRENT_WALLPAPER_FILE"
    echo "Saved current wallpaper: $wallpaper"
}

# Function to load last wallpaper
load_last_wallpaper() {
    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        local last_wallpaper=$(cat "$CURRENT_WALLPAPER_FILE")
        if [ -f "$last_wallpaper" ]; then
            echo "Loading last wallpaper: $last_wallpaper"

            # Ensure hyprpaper is running
            if ! pgrep -x hyprpaper > /dev/null; then
                hyprpaper &
                sleep 2
            fi

            # Set the wallpaper
            hyprctl hyprpaper preload "$last_wallpaper" 2>/dev/null
            sleep 0.5
            hyprctl hyprpaper wallpaper ",$last_wallpaper"
            return 0
        fi
    fi

    # Fallback to first available wallpaper
    local first_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 1)
    if [ -n "$first_wallpaper" ]; then
        echo "No saved wallpaper, using: $first_wallpaper"
        save_current_wallpaper "$first_wallpaper"

        if ! pgrep -x hyprpaper > /dev/null; then
            hyprpaper &
            sleep 2
        fi

        hyprctl hyprpaper preload "$first_wallpaper" 2>/dev/null
        sleep 0.5
        hyprctl hyprpaper wallpaper ",$first_wallpaper"
    fi
}

# Function to generate dynamic hyprpaper config
generate_config() {
    local current_wallpaper=""

    # Get current wallpaper or use first available
    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        current_wallpaper=$(cat "$CURRENT_WALLPAPER_FILE")
    fi

    if [ ! -f "$current_wallpaper" ]; then
        current_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 1)
    fi

    # Generate new config
    cat > "$HYPRPAPER_CONFIG" << EOF
# Auto-generated hyprpaper config
# This file is updated automatically to remember last wallpaper

EOF

    # Preload a few wallpapers for quick switching
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 5 | while read -r wallpaper; do
        echo "preload = $wallpaper" >> "$HYPRPAPER_CONFIG"
    done

    echo "" >> "$HYPRPAPER_CONFIG"

    # Set current wallpaper
    if [ -n "$current_wallpaper" ]; then
        echo "wallpaper = ,$current_wallpaper" >> "$HYPRPAPER_CONFIG"
    fi

    cat >> "$HYPRPAPER_CONFIG" << EOF

splash = false
ipc = on
EOF
}

# Handle different actions
case "$1" in
    "save")
        save_current_wallpaper "$2"
        ;;
    "load")
        load_last_wallpaper
        ;;
    "generate-config")
        generate_config
        ;;
    *)
        echo "Usage: $0 {save|load|generate-config} [wallpaper_path]"
        echo "  save <path>     - Save current wallpaper"
        echo "  load            - Load last saved wallpaper"
        echo "  generate-config - Generate hyprpaper config with current wallpaper"
        ;;
esac
