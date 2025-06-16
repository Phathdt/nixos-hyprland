#!/usr/bin/env bash

echo "🔍 Simple Fcitx5 Test"
echo "===================="
echo ""

# Step 1: Check if fcitx5 command exists
echo "Step 1: Checking Fcitx5 installation..."
if command -v fcitx5 >/dev/null 2>&1; then
    echo "✅ Fcitx5 command found: $(which fcitx5)"
else
    echo "❌ Fcitx5 command not found"
    echo "💡 Make sure you've rebuilt NixOS with Fcitx5 config"
    exit 1
fi

# Step 2: Check fcitx5-remote
echo ""
echo "Step 2: Checking fcitx5-remote..."
if command -v fcitx5-remote >/dev/null 2>&1; then
    echo "✅ fcitx5-remote found: $(which fcitx5-remote)"
else
    echo "❌ fcitx5-remote not found"
    exit 1
fi

# Step 3: Check if fcitx5 is already running
echo ""
echo "Step 3: Checking if Fcitx5 is running..."
if pgrep -x "fcitx5" > /dev/null; then
    echo "✅ Fcitx5 is already running (PID: $(pgrep -x fcitx5))"
    FCITX5_RUNNING=true
else
    echo "⚠️  Fcitx5 is not running"
    FCITX5_RUNNING=false
fi

# Step 4: Start fcitx5 if not running
if [ "$FCITX5_RUNNING" = false ]; then
    echo ""
    echo "Step 4: Starting Fcitx5..."
    fcitx5 -d &
    sleep 3

    if pgrep -x "fcitx5" > /dev/null; then
        echo "✅ Fcitx5 started successfully (PID: $(pgrep -x fcitx5))"
    else
        echo "❌ Failed to start Fcitx5"
        exit 1
    fi
else
    echo ""
    echo "Step 4: Skipping start (already running)"
fi

# Step 5: Test fcitx5-remote connection
echo ""
echo "Step 5: Testing fcitx5-remote connection..."
if fcitx5-remote >/dev/null 2>&1; then
    echo "✅ fcitx5-remote connection successful"
else
    echo "❌ Cannot connect to Fcitx5"
    echo "💡 Waiting 3 seconds and trying again..."
    sleep 3
    if fcitx5-remote >/dev/null 2>&1; then
        echo "✅ fcitx5-remote connection successful (after wait)"
    else
        echo "❌ Still cannot connect to Fcitx5"
        exit 1
    fi
fi

# Step 6: Check current input method
echo ""
echo "Step 6: Checking current input method..."
current_im=$(fcitx5-remote -n 2>/dev/null)
if [ -n "$current_im" ]; then
    echo "✅ Current input method: $current_im"
else
    echo "⚠️  No current input method set"
fi

# Step 7: Test switching to unikey
echo ""
echo "Step 7: Testing switch to Unikey..."
if fcitx5-remote -s unikey 2>/dev/null; then
    echo "✅ Successfully switched to Unikey"
    new_im=$(fcitx5-remote -n 2>/dev/null)
    echo "📍 New input method: $new_im"
else
    echo "❌ Failed to switch to Unikey"
    echo "💡 Unikey engine might not be available"
fi

# Step 8: Test switching back to English
echo ""
echo "Step 8: Testing switch to English..."
if fcitx5-remote -s keyboard-us 2>/dev/null; then
    echo "✅ Successfully switched to English"
    new_im=$(fcitx5-remote -n 2>/dev/null)
    echo "📍 New input method: $new_im"
else
    echo "❌ Failed to switch to English"
fi

echo ""
echo "🎯 Test completed!"
echo "================="
echo ""
echo "If everything works:"
echo "1. Start Waybar: waybar &"
echo "2. Test toggle: Ctrl+Super+Alt+Space"
echo "3. Open text editor and try typing Vietnamese"
