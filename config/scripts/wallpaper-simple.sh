#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Check if wallpapers exist
if [ ! -d "$WALLPAPER_DIR" ] || [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
    notify-send -a "Wallpaper" "No Wallpapers" "No wallpapers found in $WALLPAPER_DIR\nAdd some images to get started!"
    exit 1
fi

# Create menu options
{
    echo "🎲 Random Wallpaper"
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) -exec basename {} \;
} | rofi -dmenu -i -p "Select Wallpaper" -theme ~/.config/rofi/wallpaper-menu.rasi -format 's' | {
    read -r selection

    if [ "$selection" = "🎲 Random Wallpaper" ]; then
        # Random wallpaper
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)
        if [ -n "$WALLPAPER" ]; then
            hyprctl hyprpaper wallpaper ",$WALLPAPER"
            notify-send -a "Wallpaper" "Random Wallpaper" "Set: $(basename "$WALLPAPER")"
        fi
    elif [ -n "$selection" ]; then
        # Specific wallpaper selected
        WALLPAPER="$WALLPAPER_DIR/$selection"
        if [ -f "$WALLPAPER" ]; then
            hyprctl hyprpaper preload "$WALLPAPER"
            hyprctl hyprpaper wallpaper ",$WALLPAPER"
            notify-send -a "Wallpaper" "Wallpaper Changed" "Set: $selection"
        fi
    fi
}
