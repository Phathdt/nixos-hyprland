#!/usr/bin/env bash

echo "🔧 Fixing Bamboo Engine Configuration"
echo "===================================="
echo ""

# Kill existing IBus processes
echo "1. Stopping existing IBus processes..."
pkill -f ibus
sleep 2

# Start IBus daemon
echo "2. Starting IBus daemon..."
ibus-daemon -drx &
sleep 3

# Check if IBus daemon is running
if pgrep -x "ibus-daemon" > /dev/null; then
    echo "   ✅ IBus daemon started successfully"
else
    echo "   ❌ Failed to start IBus daemon"
    exit 1
fi

# List all available engines
echo ""
echo "3. Checking available engines..."
engines=$(ibus list-engine 2>/dev/null)

if [ -z "$engines" ]; then
    echo "   ❌ No engines found. Waiting for IBus to initialize..."
    sleep 5
    engines=$(ibus list-engine 2>/dev/null)
fi

echo "   📋 Available engines:"
echo "$engines" | head -20 | sed 's/^/      /'

# Look for Bamboo specifically
echo ""
echo "4. Looking for Bamboo engine..."
bamboo_engines=$(echo "$engines" | grep -i bamboo)

if [ -n "$bamboo_engines" ]; then
    echo "   ✅ Found Bamboo engines:"
    echo "$bamboo_engines" | sed 's/^/      /'

    # Extract the exact engine name
    bamboo_name=$(echo "$bamboo_engines" | head -1 | awk '{print $1}')
    echo "   📍 Using engine: $bamboo_name"

    # Try to set Bamboo as current engine
    echo ""
    echo "5. Setting Bamboo as current engine..."
    if ibus engine "$bamboo_name" 2>/dev/null; then
        echo "   ✅ Successfully set Bamboo engine"
        current=$(ibus engine 2>/dev/null)
        echo "   📍 Current engine: $current"
    else
        echo "   ❌ Failed to set Bamboo engine"
    fi
else
    echo "   ❌ No Bamboo engines found"
    echo ""
    echo "   🔍 Troubleshooting:"
    echo "   - Check if ibus-bamboo package is installed:"
    echo "     nix-env -q | grep bamboo"
    echo "   - Check NixOS configuration:"
    echo "     grep -r bamboo /etc/nixos/"
    echo "   - Rebuild NixOS:"
    echo "     sudo nixos-rebuild switch"
fi

# Configure IBus preferences
echo ""
echo "6. Configuring IBus preferences..."
if command -v gsettings >/dev/null 2>&1; then
    # Set preload engines
    if [ -n "$bamboo_engines" ]; then
        bamboo_name=$(echo "$bamboo_engines" | head -1 | awk '{print $1}')
        gsettings set org.freedesktop.ibus.general preload-engines "['xkb:us::eng', '$bamboo_name']" 2>/dev/null || true
        gsettings set org.freedesktop.ibus.general engines-order "['xkb:us::eng', '$bamboo_name']" 2>/dev/null || true
        echo "   ✅ IBus preferences configured"
    else
        echo "   ⚠️  Skipping preferences - no Bamboo engine found"
    fi
else
    echo "   ⚠️  gsettings not available - skipping preferences"
fi

echo ""
echo "7. Final test..."
current_engine=$(ibus engine 2>/dev/null)
echo "   📍 Current engine: $current_engine"

# Test the status script
if [ -x ~/.config/scripts/input-method-status.sh ]; then
    status=$(~/.config/scripts/input-method-status.sh)
    echo "   📊 Status script output: '$status'"
fi

echo ""
echo "🎯 Next steps:"
echo "============="
echo "1. Restart Waybar: pkill waybar && waybar &"
echo "2. Test toggle: Ctrl+Super+Alt+Space"
echo "3. Open text editor and try typing: tieeng vieejt"
echo "4. Should become: tiếng việt"
