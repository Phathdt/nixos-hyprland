#!/usr/bin/env bash

echo "=== Wallpaper System Debug ==="
echo

echo "1. Checking Hyprpaper process:"
if pgrep -x hyprpaper > /dev/null; then
    echo "✅ Hyprpaper is running (PID: $(pgrep -x hyprpaper))"
else
    echo "❌ Hyprpaper is NOT running"
fi
echo

echo "2. Checking Hyprpaper config:"
if [ -f ~/.config/hypr/hyprpaper.conf ]; then
    echo "✅ Config exists: ~/.config/hypr/hyprpaper.conf"
    echo "Config content:"
    cat ~/.config/hypr/hyprpaper.conf
else
    echo "❌ Config missing: ~/.config/hypr/hyprpaper.conf"
fi
echo

echo "3. Checking wallpaper directory:"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
if [ -d "$WALLPAPER_DIR" ]; then
    WALLPAPER_COUNT=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | wc -l)
    echo "✅ Wallpaper directory exists: $WALLPAPER_DIR"
    echo "📁 Found $WALLPAPER_COUNT wallpapers:"
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) -exec basename {} \;
else
    echo "❌ Wallpaper directory missing: $WALLPAPER_DIR"
fi
echo

echo "4. Testing hyprctl commands:"
echo "Testing hyprctl hyprpaper listloaded:"
hyprctl hyprpaper listloaded 2>&1
echo

echo "Testing hyprctl hyprpaper listactive:"
hyprctl hyprpaper listactive 2>&1
echo

echo "5. Manual test - setting first wallpaper:"
FIRST_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 1)
if [ -n "$FIRST_WALLPAPER" ]; then
    echo "Attempting to set: $FIRST_WALLPAPER"
    echo "Preloading..."
    hyprctl hyprpaper preload "$FIRST_WALLPAPER"
    echo "Setting wallpaper..."
    hyprctl hyprpaper wallpaper ",$FIRST_WALLPAPER"
    echo "Done!"
else
    echo "No wallpapers found to test"
fi
