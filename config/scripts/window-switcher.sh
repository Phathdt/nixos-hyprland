#!/usr/bin/env bash

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Get window list and create simple menu
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true and .workspace.id > 0) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Clean up title
        clean_title=$(echo "$title" | tr -d '\n\r' | cut -c1-50)

        # Add indicators
        indicators=""
        [ "$floating" = "true" ] && indicators="${indicators} [Float]"
        [ "$fullscreen" = "true" ] && indicators="${indicators} [Full]"

        # Simple format: display_text|address
        printf "[WS%s] %s: %s%s|%s\n" "$workspace" "$class" "$clean_title" "$indicators" "$address"
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
