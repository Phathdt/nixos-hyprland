#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
THUMBNAIL_DIR="$HOME/.cache/wallpaper-thumbnails"
TEMP_DIR="/tmp/wallpaper-menu"

# Create directories
mkdir -p "$WALLPAPER_DIR" "$THUMBNAIL_DIR" "$TEMP_DIR"

# Function to generate thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"

    if command -v convert >/dev/null 2>&1; then
        # Using ImageMagick
        convert "$input" -resize 200x150^ -gravity center -extent 200x150 "$output" 2>/dev/null
    elif command -v ffmpeg >/dev/null 2>&1; then
        # Using ffmpeg as fallback
        ffmpeg -i "$input" -vf "scale=200:150:force_original_aspect_ratio=increase,crop=200:150" "$output" -y 2>/dev/null
    else
        # No thumbnail generator available
        return 1
    fi
}

# Function to create desktop entries for wallpapers
create_desktop_entries() {
    # Create applications directory structure
    mkdir -p "$TEMP_DIR/applications"
    rm -rf "$TEMP_DIR/applications"/*.desktop 2>/dev/null

    local count=0
    while IFS= read -r -d '' wallpaper; do
        local basename=$(basename "$wallpaper")
        local name="${basename%.*}"
        local thumbnail="$THUMBNAIL_DIR/${basename}.png"
        local desktop_file="$TEMP_DIR/applications/wallpaper-${name}.desktop"

        # Generate thumbnail if it doesn't exist
        if [ ! -f "$thumbnail" ]; then
            if generate_thumbnail "$wallpaper" "$thumbnail"; then
                echo "Generated thumbnail for $basename"
            else
                # Use a default icon if thumbnail generation fails
                thumbnail="image-x-generic"
            fi
        fi

        # Create desktop entry with proper escaping
        cat > "$desktop_file" << EOF
[Desktop Entry]
Type=Application
Name=$name
Comment=Set wallpaper: $basename
Exec=sh -c 'hyprctl hyprpaper wallpaper ",$wallpaper" && notify-send -a "Wallpaper" "Wallpaper Changed" "Set: $basename"'
Icon=$thumbnail
Categories=Graphics;
NoDisplay=false
StartupNotify=false
EOF
        ((count++))
    done < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) -print0)

    echo "Created $count wallpaper entries"
}

# Function to show wallpaper menu
show_menu() {
    if [ ! -d "$WALLPAPER_DIR" ] || [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
        notify-send "Wallpaper Menu" "No wallpapers found in $WALLPAPER_DIR\nAdd some images to get started!"
        return 1
    fi

    create_desktop_entries

    # Show rofi menu with custom theme
    export XDG_DATA_DIRS="$TEMP_DIR:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    rofi -show drun \
         -drun-categories Graphics \
         -theme ~/.config/rofi/wallpaper-menu.rasi \
         -drun-match-fields name,comment \
         -drun-display-format "{name}" \
         -show-icons \
         -icon-theme "Papirus" \
         -markup-rows \
         -eh 2 \
         -width 60 \
         -padding 20 \
         -lines 8 \
         -columns 3
}

# Function to add random wallpaper option
add_random_option() {
    cat > "$TEMP_DIR/applications/wallpaper-random.desktop" << EOF
[Desktop Entry]
Type=Application
Name=🎲 Random Wallpaper
Comment=Set a random wallpaper
Exec=sh -c '$0 random-exec'
Icon=preferences-desktop-wallpaper
Categories=Graphics;
NoDisplay=false
StartupNotify=false
EOF
}

# Handle different actions
case "$1" in
    "random-exec")
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)
        if [ -n "$WALLPAPER" ]; then
            hyprctl hyprpaper wallpaper ",$WALLPAPER"
            notify-send "Wallpaper" "Random wallpaper set: $(basename "$WALLPAPER")"
        else
            notify-send "Wallpaper" "No wallpapers found!"
        fi
        ;;
    *)
        add_random_option
        show_menu
        ;;
esac
