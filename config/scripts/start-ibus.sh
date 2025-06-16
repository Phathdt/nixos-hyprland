#!/usr/bin/env bash

echo "🚀 Starting IBus for Vietnamese Input"
echo "===================================="
echo ""

# Kill any existing IBus processes
echo "1. Stopping existing IBus processes..."
pkill -f ibus 2>/dev/null || true
sleep 2

# Start IBus daemon
echo "2. Starting IBus daemon..."
ibus-daemon -drx &
sleep 3

# Check if IBus daemon is running
echo "3. Checking IBus daemon status..."
if pgrep -x "ibus-daemon" > /dev/null; then
    echo "   ✅ IBus daemon is running (PID: $(pgrep -x ibus-daemon))"
else
    echo "   ❌ IBus daemon failed to start"
    echo "   💡 Try manually: ibus-daemon -drx"
    exit 1
fi

# Test IBus connection
echo ""
echo "4. Testing IBus connection..."
if ibus list-engine >/dev/null 2>&1; then
    echo "   ✅ IBus connection successful"
else
    echo "   ❌ Cannot connect to IBus"
    echo "   💡 Waiting 5 more seconds for IBus to initialize..."
    sleep 5
    if ibus list-engine >/dev/null 2>&1; then
        echo "   ✅ IBus connection successful (after wait)"
    else
        echo "   ❌ Still cannot connect to IBus"
        exit 1
    fi
fi

# List available engines
echo ""
echo "5. Available IBus engines:"
engines=$(ibus list-engine 2>/dev/null)
if [ -n "$engines" ]; then
    echo "$engines" | head -20 | sed 's/^/   /'

    # Look for Bamboo engines
    echo ""
    echo "6. Looking for Bamboo engines..."
    bamboo_engines=$(echo "$engines" | grep -i bamboo)
    if [ -n "$bamboo_engines" ]; then
        echo "   ✅ Found Bamboo engines:"
        echo "$bamboo_engines" | sed 's/^/      /'
    else
        echo "   ❌ No Bamboo engines found"
        echo "   💡 Make sure you've rebuilt NixOS with ibus-bamboo config"
    fi
else
    echo "   ❌ No engines available"
fi

# Set up default engines (from official documentation)
echo ""
echo "7. Setting up default engines..."
if command -v dconf >/dev/null 2>&1; then
    env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" 2>/dev/null || true
    echo "   ✅ Default engines configured"
else
    echo "   ⚠️  dconf not available, skipping engine setup"
fi

# Test current engine
echo ""
echo "8. Testing engine switching..."
current=$(ibus engine 2>/dev/null)
echo "   📍 Current engine: ${current:-none}"

# Try to set Bamboo engine if available
if echo "$engines" | grep -q "Bamboo"; then
    echo "   🔄 Trying to set Bamboo engine..."
    if ibus engine Bamboo 2>/dev/null; then
        echo "   ✅ Successfully set Bamboo engine"
        new_current=$(ibus engine 2>/dev/null)
        echo "   📍 New current engine: $new_current"
    else
        echo "   ❌ Failed to set Bamboo engine"
    fi
fi

echo ""
echo "🎯 Next steps:"
echo "============="
echo "1. Start Waybar: waybar &"
echo "2. Test toggle: Ctrl+Super+Alt+Space"
echo "3. Open text editor and try: tieeng vieejt"
echo "4. Should become: tiếng việt"
