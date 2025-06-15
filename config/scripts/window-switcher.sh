#!/usr/bin/env bash

# Get window list with workspace info
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)"' | while IFS='|' read -r address workspace class title; do
        # Format: [Workspace] Class: Title
        printf "[%s] %s: %s|%s\n" "$workspace" "$class" "$title" "$address"
    done
}

# Show window menu
selected=$(get_windows | rofi -dmenu -i -p "Switch to Window" \
    -theme-str 'window {width: 600px; height: 400px;}' \
    -theme-str 'listview {lines: 12;}' \
    -format 's')

if [ -n "$selected" ]; then
    # Extract window address
    address=$(echo "$selected" | cut -d'|' -f2)

    if [ -n "$address" ]; then
        # Focus the window (this will also switch workspace if needed)
        hyprctl dispatch focuswindow "address:$address"
    fi
fi
