#!/usr/bin/env bash

# Rofi Theme Switcher Script
# Usage: ./switch-theme.sh [theme-name]

ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
THEMES_DIR="$HOME/.config/rofi/themes"

# Available themes
declare -A THEMES=(
    ["palenight"]="material-palenight.rasi"
    ["palenight-transparent"]="material-palenight-transparent.rasi"
    ["catppuccin"]="catppuccin-macchiato.rasi"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_usage() {
    echo -e "${BLUE}Rofi Theme Switcher${NC}"
    echo ""
    echo "Usage: $0 [theme-name]"
    echo ""
    echo "Available themes:"
    for theme in "${!THEMES[@]}"; do
        echo -e "  ${PURPLE}$theme${NC} - ${THEMES[$theme]}"
    done
    echo ""
    echo "Examples:"
    echo "  $0 palenight"
    echo "  $0 palenight-transparent"
    echo "  $0 catppuccin"
}

switch_theme() {
    local theme_name="$1"
    local theme_file="${THEMES[$theme_name]}"

    if [[ -z "$theme_file" ]]; then
        echo -e "${RED}Error: Theme '$theme_name' not found${NC}"
        print_usage
        exit 1
    fi

    if [[ ! -f "$THEMES_DIR/$theme_file" ]]; then
        echo -e "${RED}Error: Theme file '$theme_file' not found in $THEMES_DIR${NC}"
        exit 1
    fi

    # Backup current config
    cp "$ROFI_CONFIG" "$ROFI_CONFIG.backup"

    # Update theme line in config
    sed -i "s|@theme \".*\"|@theme \"~/.config/rofi/themes/$theme_file\"|" "$ROFI_CONFIG"

    echo -e "${GREEN}✓ Switched to theme: $theme_name${NC}"
    echo -e "${YELLOW}Theme file: $theme_file${NC}"
    echo ""
    echo "Test the theme with: rofi -show drun"
}

# Main logic
if [[ $# -eq 0 ]]; then
    print_usage
    exit 0
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

switch_theme "$1"
