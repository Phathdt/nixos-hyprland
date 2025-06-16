#!/usr/bin/env bash

echo "🚀 Setting up Fcitx5 for Vietnamese Input"
echo "========================================="
echo ""

# Check if Fcitx5 is installed
echo "1. Checking Fcitx5 installation..."
if command -v fcitx5 >/dev/null 2>&1; then
    echo "   ✅ Fcitx5 found: $(which fcitx5)"
else
    echo "   ❌ Fcitx5 not found"
    echo "   💡 Make sure you've rebuilt NixOS with Fcitx5 config"
    exit 1
fi

# Check if fcitx5-remote is available
if command -v fcitx5-remote >/dev/null 2>&1; then
    echo "   ✅ fcitx5-remote found: $(which fcitx5-remote)"
else
    echo "   ❌ fcitx5-remote not found"
    exit 1
fi

# Kill existing Fcitx5 processes
echo ""
echo "2. Stopping existing Fcitx5 processes..."
if pgrep -f fcitx5 >/dev/null 2>&1; then
    echo "   Found existing Fcitx5 processes, stopping them..."
    pkill -f fcitx5 2>/dev/null || true
    sleep 2
    echo "   ✅ Cleanup completed"
else
    echo "   ✅ No existing Fcitx5 processes found"
fi

# Start Fcitx5
echo ""
echo "3. Starting Fcitx5..."
fcitx5 -d &
sleep 3

# Check if Fcitx5 is running
if pgrep -x "fcitx5" > /dev/null; then
    echo "   ✅ Fcitx5 is running (PID: $(pgrep -x fcitx5))"
else
    echo "   ❌ Fcitx5 failed to start"
    exit 1
fi

# Test Fcitx5 connection
echo ""
echo "4. Testing Fcitx5 connection..."
if fcitx5-remote >/dev/null 2>&1; then
    echo "   ✅ Fcitx5 connection successful"
else
    echo "   ❌ Cannot connect to Fcitx5"
    echo "   💡 Waiting 5 seconds for initialization..."
    sleep 5
    if fcitx5-remote >/dev/null 2>&1; then
        echo "   ✅ Fcitx5 connection successful (after wait)"
    else
        echo "   ❌ Still cannot connect to Fcitx5"
        exit 1
    fi
fi

# Check current input method
echo ""
echo "5. Checking current input method..."
current_im=$(fcitx5-remote -n 2>/dev/null)
echo "   📍 Current input method: ${current_im:-none}"

# Test switching to Vietnamese
echo ""
echo "6. Testing Vietnamese input method..."
if fcitx5-remote -s unikey 2>/dev/null; then
    echo "   ✅ Successfully switched to Unikey"
    new_im=$(fcitx5-remote -n 2>/dev/null)
    echo "   📍 New input method: $new_im"
else
    echo "   ❌ Failed to switch to Unikey"
    echo "   💡 Unikey engine might not be available"
fi

# Test switching back to English
echo ""
echo "7. Testing English input method..."
if fcitx5-remote -s keyboard-us 2>/dev/null; then
    echo "   ✅ Successfully switched to English"
    new_im=$(fcitx5-remote -n 2>/dev/null)
    echo "   📍 New input method: $new_im"
else
    echo "   ❌ Failed to switch to English"
fi

# Test status script
echo ""
echo "8. Testing status script..."
if [ -x ~/.config/scripts/input-method-status.sh ]; then
    status=$(~/.config/scripts/input-method-status.sh)
    echo "   📊 Status script output: '$status'"
else
    echo "   ⚠️  Status script not found or not executable"
fi

echo ""
echo "🎯 Setup completed!"
echo "=================="
echo ""
echo "Usage:"
echo "  - Ctrl + Super + Alt + Space: Toggle input method"
echo "  - Or click on Waybar indicator"
echo ""
echo "Test typing:"
echo "  1. Open a text editor"
echo "  2. Toggle to Vietnamese mode"
echo "  3. Type: tieeng vieejt"
echo "  4. Should become: tiếng việt"
echo ""
echo "Next steps:"
echo "  1. Start Waybar: waybar &"
echo "  2. Test the toggle keybinding"
