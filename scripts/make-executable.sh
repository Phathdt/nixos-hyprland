#!/usr/bin/env bash

echo "🔧 Making all scripts executable..."

# Make all scripts in config/scripts executable
find config/scripts -name "*.sh" -type f -exec chmod +x {} \;

# Make init.sh executable
chmod +x init.sh

# List all scripts with their permissions
echo ""
echo "📋 Script permissions:"
echo "=== Main Scripts ==="
ls -la init.sh

echo ""
echo "=== Config Scripts ==="
ls -la config/scripts/*.sh

echo ""
echo "✅ All scripts are now executable!"
echo ""
echo "📝 Available scripts:"
echo "  • init.sh - Main setup script"
echo "  • config/scripts/wallpaper-menu.sh - Wallpaper selector with thumbnails"
echo "  • config/scripts/wallpaper-persistence.sh - Wallpaper persistence system"
echo "  • config/scripts/wifi-menu.sh - WiFi network manager"
echo "  • config/scripts/wifi-menu-wrapper.sh - WiFi menu wrapper for Waybar"
echo "  • config/scripts/window-switcher.sh - Alt+Tab window switcher"
echo "  • config/scripts/clipboard-menu.sh - Clipboard history menu"
echo "  • config/scripts/app-launcher.sh - Application launcher"
