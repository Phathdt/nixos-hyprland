#!/usr/bin/env bash

echo "🖥️  Monitor Information"
echo "======================"
echo ""

# Check if running on Hyprland
if command -v hyprctl >/dev/null 2>&1; then
    echo "📊 Current Hyprland Monitors:"
    echo "----------------------------"
    hyprctl monitors
    echo ""

    echo "📋 Available Outputs:"
    echo "--------------------"
    hyprctl monitors | grep -E "Monitor|at|transform" | head -20
    echo ""

    echo "🔧 Current Monitor Configuration:"
    echo "--------------------------------"
    grep "^monitor=" ~/.config/hypr/modules/monitors.conf 2>/dev/null || echo "No monitor config found"
    echo ""
fi

# Check wlr-randr if available
if command -v wlr-randr >/dev/null 2>&1; then
    echo "📺 wlr-randr Output Information:"
    echo "-------------------------------"
    wlr-randr
    echo ""
fi

# Check xrandr if available (for X11 fallback)
if command -v xrandr >/dev/null 2>&1; then
    echo "🖼️  xrandr Output Information:"
    echo "-----------------------------"
    xrandr --listmonitors 2>/dev/null || echo "Not running on X11"
    echo ""
fi

echo "💡 Tips:"
echo "-------"
echo "• Use monitor names from 'Monitor' lines above"
echo "• Common names: DP-1, DP-2, HDMI-A-1, eDP-1"
echo "• Edit ~/.config/hypr/modules/monitors.conf with correct names"
echo "• Reload Hyprland: hyprctl reload"
echo ""
echo "📝 Current Configuration Template:"
echo "---------------------------------"
echo "monitor=YOUR_4K_MONITOR,3840x2160@60,0x0,2.0"
echo "monitor=YOUR_ULTRAWIDE,3440x1440@70,1920x0,1.0"
echo "monitor=HEADLESS-1,1920x1080@60,5360x0,1.0"
