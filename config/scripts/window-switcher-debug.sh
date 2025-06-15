#!/usr/bin/env bash

echo "=== Window Switcher Debug ==="

# Kill any existing rofi instances first
pkill rofi 2>/dev/null

# Get detailed window information
echo "Raw window data from hyprctl:"
hyprctl clients -j | jq -r '.[] | select(.mapped == true) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.pid)|\(.floating)|\(.fullscreen)"'

echo ""
echo "Formatted window list:"

# Get window list with workspace info
get_windows() {
    hyprctl clients -j | jq -r '.[] | select(.mapped == true) | "\(.address)|\(.workspace.id)|\(.class)|\(.title)|\(.floating)|\(.fullscreen)"' | while IFS='|' read -r address workspace class title floating fullscreen; do
        # Add state indicators
        state=""
        [ "$floating" = "true" ] && state="${state}[FLOATING]"
        [ "$fullscreen" = "true" ] && state="${state}[FULLSCREEN]"

        # Format: [Workspace] Class: Title [State]
        printf "[WS%s] %s: %s %s|%s\n" "$workspace" "$class" "$title" "$state" "$address"
    done
}

get_windows

echo ""
echo "Testing window focus..."

# Show window menu
selected=$(get_windows | rofi -dmenu -i -p "Switch to Window (Debug)" \
    -theme-str 'window {width: 800px; height: 400px;}' \
    -theme-str 'listview {lines: 12;}' \
    -auto-select \
    -no-lazy-grab \
    -format 's')

if [ -n "$selected" ]; then
    # Extract window address
    address=$(echo "$selected" | cut -d'|' -f2)

    echo "Selected: $selected"
    echo "Address: $address"

    if [ -n "$address" ]; then
        echo "Attempting to focus window with address: $address"

        # Try different focus methods
        echo "Method 1: focuswindow address:$address"
        hyprctl dispatch focuswindow "address:$address"

        sleep 1

        echo "Method 2: focuswindow pid (if method 1 fails)"
        # Get PID and try focusing by PID
        pid=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | .pid")
        if [ -n "$pid" ]; then
            echo "PID: $pid"
            hyprctl dispatch focuswindow "pid:$pid"
        fi

        sleep 1

        echo "Method 3: focuswindow class (if others fail)"
        # Get class and try focusing by class
        class=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$address\") | .class")
        if [ -n "$class" ]; then
            echo "Class: $class"
            hyprctl dispatch focuswindow "$class"
        fi
    fi
fi
