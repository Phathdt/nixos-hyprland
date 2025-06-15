#!/usr/bin/env bash

MONITOR_NAME="HDMI-A-1"  # Change this to your actual 4K monitor name

echo "🖥️  Testing 4K Monitor Scaling Options"
echo "====================================="
echo ""
echo "Monitor: $MONITOR_NAME"
echo ""

# Function to apply scaling and show info
test_scale() {
    local scale=$1
    local description=$2

    echo "🔧 Testing Scale $scale - $description"
    echo "Command: hyprctl keyword monitor $MONITOR_NAME,3840x2160@60,0x0,$scale"

    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl keyword monitor "$MONITOR_NAME,3840x2160@60,0x0,$scale"
        echo "✅ Applied! Check text clarity now."
    else
        echo "⚠️  hyprctl not available - run this on NixOS with Hyprland"
    fi

    echo "Press Enter to continue to next scale (or Ctrl+C to stop)..."
    read -r
    echo ""
}

echo "We'll test different scaling options for best text clarity:"
echo ""

# Test different scales
test_scale "2.0" "Standard FHD equivalent (current)"
test_scale "1.75" "Slightly larger workspace, potentially sharper"
test_scale "1.5" "Larger workspace, better text clarity"
test_scale "1.25" "Much larger workspace, sharpest text"
test_scale "1.0" "Native 4K, very small but crisp text"

echo "🎯 Testing Complete!"
echo ""
echo "💡 Tips for best results:"
echo "• Scale 1.25-1.5 usually gives best text clarity"
echo "• Scale 2.0 gives FHD-like workspace size"
echo "• Lower scale = sharper text but smaller UI"
echo "• Higher scale = larger UI but potentially blurrier"
echo ""
echo "📝 To make permanent, edit ~/.config/hypr/modules/monitors.conf"
echo "   Change the scale value in the monitor line for $MONITOR_NAME"
echo ""
echo "🔄 Current monitor config:"
grep "^monitor=$MONITOR_NAME" ~/.config/hypr/modules/monitors.conf 2>/dev/null || echo "Monitor config not found"
