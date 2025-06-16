#!/usr/bin/env bash

echo "🔧 Manual Fcitx5 Setup"
echo "====================="
echo ""

# Kill existing fcitx5
echo "1. Stopping existing Fcitx5..."
pkill -f fcitx5 2>/dev/null || true
sleep 2

# Start fcitx5
echo "2. Starting Fcitx5..."
fcitx5 -d &
sleep 3

# Check if fcitx5-configtool is available
if command -v fcitx5-configtool >/dev/null 2>&1; then
    echo "3. Opening Fcitx5 configuration tool..."
    echo "   Please follow these steps in the GUI:"
    echo "   - Click 'Add Input Method'"
    echo "   - Search for 'Unikey' or 'Vietnamese'"
    echo "   - Add 'Unikey' to the list"
    echo "   - Set hotkey for switching (default: Ctrl+Space)"
    echo "   - Click 'Apply' and 'OK'"
    echo ""
    echo "   Opening configuration tool in 3 seconds..."
    sleep 3
    fcitx5-configtool &
else
    echo "3. fcitx5-configtool not available, creating manual config..."

    # Create manual configuration
    config_dir="$HOME/.config/fcitx5"
    mkdir -p "$config_dir"

    # Create profile with unikey
    cat > "$config_dir/profile" << 'EOF'
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=keyboard-us

[Groups/0/Items/0]
# Name
Name=keyboard-us
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=unikey
# Layout
Layout=

[GroupOrder]
0=Default
EOF

    echo "   ✅ Manual configuration created"
fi

echo ""
echo "4. Restarting Fcitx5..."
pkill -f fcitx5 2>/dev/null || true
sleep 2
fcitx5 -d &
sleep 3

echo ""
echo "5. Testing configuration..."
if fcitx5-remote -l 2>/dev/null | grep -i unikey > /dev/null; then
    echo "   ✅ Unikey found in input method list!"
else
    echo "   ❌ Unikey still not found"
    echo "   💡 Try running fcitx5-configtool manually"
fi

echo ""
echo "🎯 Manual Setup Complete!"
echo "========================"
echo ""
echo "Test commands:"
echo "- Switch to Vietnamese: fcitx5-remote -s unikey"
echo "- Switch to English: fcitx5-remote -s keyboard-us"
echo "- Toggle: fcitx5-remote -t"
echo "- Check current: fcitx5-remote -n"
