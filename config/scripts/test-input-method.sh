#!/usr/bin/env bash

echo "Testing Input Method Indicator..."
echo ""

# Test input method status script
echo "1. Testing input-method-status.sh:"
if [ -x ~/.config/scripts/input-method-status.sh ]; then
    result=$(~/.config/scripts/input-method-status.sh)
    echo "   Current status: $result"
else
    echo "   ❌ Script not found or not executable"
fi

echo ""

# Check if IBus is running
echo "2. Checking IBus daemon:"
if pgrep -x "ibus-daemon" > /dev/null; then
    echo "   ✅ IBus daemon is running"
    current_engine=$(ibus engine 2>/dev/null)
    echo "   Current engine: $current_engine"
else
    echo "   ❌ IBus daemon is not running"
    echo "   Run: ibus-daemon -drx &"
fi

echo ""

# Check available engines
echo "3. Available IBus engines:"
if command -v ibus >/dev/null 2>&1; then
    ibus list-engine | grep -E "(Bamboo|xkb:us)" || echo "   No Vietnamese engines found"
else
    echo "   ❌ IBus command not found"
fi

echo ""

# Test toggle script
echo "4. Testing toggle script:"
if [ -x ~/.config/scripts/toggle-vietnamese.sh ]; then
    echo "   ✅ Toggle script is executable"
    echo "   Usage: Ctrl+Super+Alt+Space or Alt+Shift to toggle"
else
    echo "   ❌ Toggle script not found or not executable"
fi

echo ""

# Check Waybar config
echo "5. Checking Waybar configuration:"
if grep -q "custom/input-method" ~/.config/waybar/config.json; then
    echo "   ✅ Input method module found in Waybar config"
else
    echo "   ❌ Input method module not found in Waybar config"
fi

echo ""
echo "To restart Waybar and see changes:"
echo "   pkill waybar && waybar &"
