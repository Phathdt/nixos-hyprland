#!/usr/bin/env bash

echo "🖥️  Monitor Information"
echo "======================"
echo ""

# Check if running on Hyprland
if command -v hyprctl >/dev/null 2>&1; then
    echo "📊 Current Hyprland Monitors (Detailed):"
    echo "----------------------------------------"
    hyprctl monitors all
    echo ""

    echo "📋 Monitor Models & Specifications:"
    echo "----------------------------------"
    hyprctl monitors | while IFS= read -r line; do
        if [[ "$line" =~ ^Monitor[[:space:]]+([^[:space:]]+)[[:space:]]+\(ID[[:space:]]+([0-9]+)\): ]]; then
            monitor_name="${BASH_REMATCH[1]}"
            monitor_id="${BASH_REMATCH[2]}"
            echo "🖥️  Monitor: $monitor_name (ID: $monitor_id)"
        elif [[ "$line" =~ ^[[:space:]]+([0-9]+x[0-9]+@[0-9.]+)[[:space:]]+at[[:space:]]+([0-9]+x[0-9]+) ]]; then
            resolution="${BASH_REMATCH[1]}"
            position="${BASH_REMATCH[2]}"
            echo "   📐 Resolution: $resolution"
            echo "   📍 Position: $position"
        elif [[ "$line" =~ description:[[:space:]]*(.+) ]]; then
            description="${BASH_REMATCH[1]}"
            echo "   📝 Description: $description"
        elif [[ "$line" =~ make:[[:space:]]*(.+) ]]; then
            make="${BASH_REMATCH[1]}"
            echo "   🏭 Make: $make"
        elif [[ "$line" =~ model:[[:space:]]*(.+) ]]; then
            model="${BASH_REMATCH[1]}"
            echo "   📱 Model: $model"
        elif [[ "$line" =~ serial:[[:space:]]*(.+) ]]; then
            serial="${BASH_REMATCH[1]}"
            echo "   🔢 Serial: $serial"
        elif [[ "$line" =~ ^[[:space:]]*$ ]]; then
            echo ""
        fi
    done

    echo "🔧 Current Monitor Configuration:"
    echo "--------------------------------"
    if [ -f ~/.config/hypr/modules/monitors.conf ]; then
        cat ~/.config/hypr/modules/monitors.conf | grep -v "^#" | grep -v "^$"
    else
        echo "No monitor config found"
    fi
    echo ""

    echo "🔍 Detected Monitor Details:"
    echo "---------------------------"
    # Get detailed info using wlr-randr if available
    if command -v wlr-randr >/dev/null 2>&1; then
        wlr-randr | while IFS= read -r line; do
            if [[ "$line" =~ ^([A-Z0-9-]+)[[:space:]]+ ]]; then
                output_name="${BASH_REMATCH[1]}"
                echo "🔌 Output: $output_name"
            elif [[ "$line" =~ ^[[:space:]]+([0-9]+)[[:space:]]+x[[:space:]]+([0-9]+)[[:space:]]+px,.*@[[:space:]]*([0-9.]+)[[:space:]]*Hz ]]; then
                width="${BASH_REMATCH[1]}"
                height="${BASH_REMATCH[2]}"
                refresh="${BASH_REMATCH[3]}"
                echo "   📐 Native: ${width}x${height}@${refresh}Hz"
            elif [[ "$line" =~ Modes: ]]; then
                echo "   📋 Available modes:"
            elif [[ "$line" =~ ^[[:space:]]+([0-9]+x[0-9]+@[0-9.]+) ]]; then
                mode="${BASH_REMATCH[1]}"
                echo "      • $mode"
            fi
        done
        echo ""
    fi
fi

# Check wlr-randr if available
if command -v wlr-randr >/dev/null 2>&1; then
    echo "📺 Full wlr-randr Output:"
    echo "------------------------"
    wlr-randr
    echo ""
fi

echo "💡 Solutions for Same Port Different Monitors:"
echo "=============================================="
echo ""
echo "🎯 Option 1: Resolution-Based Detection"
echo "---------------------------------------"
echo "Create different configs based on resolution:"
echo ""
echo "# For 4K Monitor (3840x2160)"
echo "monitor=HDMI-A-1,3840x2160@60,0x0,2.0"
echo ""
echo "# For Ultrawide Monitor (3440x1440)"
echo "monitor=HDMI-A-1,3440x1440@70,0x0,1.0"
echo ""
echo "🎯 Option 2: Dynamic Monitor Scripts"
echo "------------------------------------"
echo "Create scripts that detect current monitor and apply config:"
echo ""
echo "# Check current resolution and apply appropriate scaling"
echo "CURRENT_RES=\$(hyprctl monitors | grep -A1 'HDMI-A-1' | grep -o '[0-9]*x[0-9]*')"
echo "if [[ \"\$CURRENT_RES\" == \"3840x2160\" ]]; then"
echo "    hyprctl keyword monitor HDMI-A-1,3840x2160@60,0x0,2.0"
echo "elif [[ \"\$CURRENT_RES\" == \"3440x1440\" ]]; then"
echo "    hyprctl keyword monitor HDMI-A-1,3440x1440@70,0x0,1.0"
echo "fi"
echo ""
echo "🎯 Option 3: Manual Profile Switching"
echo "-------------------------------------"
echo "Create separate config files and switch manually:"
echo ""
echo "# ~/.config/hypr/profiles/4k-monitor.conf"
echo "# ~/.config/hypr/profiles/ultrawide-monitor.conf"
echo ""
echo "# Then source the appropriate one in monitors.conf"
echo ""
echo "🔄 Quick Commands:"
echo "-----------------"
echo "# Apply 4K config:"
echo "hyprctl keyword monitor HDMI-A-1,3840x2160@60,0x0,2.0"
echo ""
echo "# Apply Ultrawide config:"
echo "hyprctl keyword monitor HDMI-A-1,3440x1440@70,0x0,1.0"
echo ""
echo "# Reload Hyprland config:"
echo "hyprctl reload"
