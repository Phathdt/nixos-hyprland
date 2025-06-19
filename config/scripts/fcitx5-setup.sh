#!/usr/bin/env bash

echo "🔧 fcitx5 Setup and Configuration"
echo "================================="
echo ""

# Kill any existing fcitx5 processes
echo "📋 Stopping existing fcitx5 processes..."
pkill -f fcitx5 2>/dev/null
sleep 2

# Check and set environment variables
echo "📋 Setting environment variables..."
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Start fcitx5
echo "📋 Starting fcitx5..."
fcitx5 -d --replace

# Wait for fcitx5 to start
echo "📋 Waiting for fcitx5 to initialize..."
sleep 3

# Check if fcitx5 is running
if pgrep -f fcitx5 > /dev/null; then
    echo "  ✅ fcitx5 is running (PID: $(pgrep -f fcitx5))"
else
    echo "  ❌ fcitx5 failed to start"
    echo "  🔄 Trying alternative start method..."
    fcitx5 &
    sleep 3
fi

# List available input methods
echo ""
echo "📋 Available input methods:"
fcitx5-remote -l 2>/dev/null || echo "  ❌ Cannot list input methods"

# Current status
echo ""
echo "📋 Current status:"
echo "  fcitx5-remote: $(fcitx5-remote 2>/dev/null || echo 'failed')"
echo "  Current IM: $(fcitx5-remote -n 2>/dev/null || echo 'unknown')"

# Try to add unikey if not available
echo ""
echo "📋 Configuring input methods..."
fcitx5-remote -s keyboard-us
sleep 1
echo "  English set: $(fcitx5-remote -n)"

fcitx5-remote -s unikey
sleep 1
current_after=$(fcitx5-remote -n 2>/dev/null)
if [ "$current_after" = "unikey" ]; then
    echo "  ✅ Vietnamese (unikey) activated successfully"
    notify-send -i "input-keyboard" -t 2000 "fcitx5 Setup" "✅ Vietnamese input configured successfully!"
else
    echo "  ❌ Failed to activate unikey"
    echo "  Current: $current_after"

    # Try to configure fcitx5 through config
    echo "  🔄 Trying to reconfigure fcitx5..."

    # Create fcitx5 config if it doesn't exist
    mkdir -p ~/.config/fcitx5/conf

    # Create a basic input method configuration
    cat > ~/.config/fcitx5/profile << EOF
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=keyboard-us

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=unikey
Layout=

[GroupOrder]
0=Default
EOF

    echo "  📁 Created fcitx5 profile configuration"
    echo "  🔄 Restarting fcitx5..."

    pkill -f fcitx5
    sleep 2
    fcitx5 -d --replace
    sleep 3

    echo "  🔄 Testing again..."
    fcitx5-remote -s unikey
    sleep 1
    final_test=$(fcitx5-remote -n 2>/dev/null)
    if [ "$final_test" = "unikey" ]; then
        echo "  ✅ Vietnamese (unikey) now working!"
        notify-send -i "input-keyboard" -t 2000 "fcitx5 Setup" "✅ Vietnamese input configured after restart!"
    else
        echo "  ❌ Still having issues. Current: $final_test"
        notify-send -i "dialog-error" -t 3000 "fcitx5 Setup" "❌ Failed to configure Vietnamese input"
    fi
fi

echo ""
echo "📋 Final status:"
echo "  fcitx5 running: $(pgrep -f fcitx5 > /dev/null && echo 'Yes' || echo 'No')"
echo "  fcitx5-remote: $(fcitx5-remote 2>/dev/null || echo 'failed')"
echo "  Current IM: $(fcitx5-remote -n 2>/dev/null || echo 'unknown')"

echo ""
echo "🎯 Test commands:"
echo "  Toggle: fcitx5-remote -t"
echo "  Set English: fcitx5-remote -s keyboard-us"
echo "  Set Vietnamese: fcitx5-remote -s unikey"
echo "  Check current: fcitx5-remote -n"
