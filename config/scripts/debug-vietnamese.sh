#!/usr/bin/env bash

echo "🔍 Vietnamese Input Method Debug Script"
echo "======================================"
echo ""

# Check IBus installation
echo "1. Checking IBus installation:"
if command -v ibus >/dev/null 2>&1; then
    echo "   ✅ IBus command found: $(which ibus)"
    ibus version 2>/dev/null || echo "   ⚠️  Could not get IBus version"
else
    echo "   ❌ IBus command not found"
fi
echo ""

# Check IBus daemon
echo "2. Checking IBus daemon:"
if pgrep -x "ibus-daemon" > /dev/null; then
    echo "   ✅ IBus daemon is running (PID: $(pgrep -x ibus-daemon))"
else
    echo "   ❌ IBus daemon is NOT running"
    echo "   💡 Try: ibus-daemon -drx &"
fi
echo ""

# Check environment variables
echo "3. Checking environment variables:"
vars=("GTK_IM_MODULE" "QT_IM_MODULE" "XMODIFIERS" "GLFW_IM_MODULE")
for var in "${vars[@]}"; do
    value=$(printenv "$var")
    if [ -n "$value" ]; then
        echo "   ✅ $var=$value"
    else
        echo "   ❌ $var is not set"
    fi
done
echo ""

# Check available engines
echo "4. Checking available IBus engines:"
if command -v ibus >/dev/null 2>&1; then
    engines=$(ibus list-engine 2>/dev/null)
    if echo "$engines" | grep -q "Bamboo"; then
        echo "   ✅ Bamboo engine found"
    else
        echo "   ❌ Bamboo engine NOT found"
    fi

    if echo "$engines" | grep -q "xkb:us::eng"; then
        echo "   ✅ English engine found"
    else
        echo "   ❌ English engine NOT found"
    fi

    echo "   📋 All engines:"
    echo "$engines" | head -10 | sed 's/^/      /'
else
    echo "   ❌ Cannot list engines - IBus not available"
fi
echo ""

# Check current engine
echo "5. Checking current engine:"
if command -v ibus >/dev/null 2>&1; then
    current=$(ibus engine 2>/dev/null)
    if [ -n "$current" ]; then
        echo "   📍 Current engine: $current"
    else
        echo "   ⚠️  No current engine set"
    fi
else
    echo "   ❌ Cannot check current engine"
fi
echo ""

# Check systemd service
echo "6. Checking systemd service:"
if systemctl --user is-active ibus-daemon >/dev/null 2>&1; then
    echo "   ✅ IBus systemd service is active"
else
    echo "   ❌ IBus systemd service is not active"
    echo "   💡 Try: systemctl --user start ibus-daemon"
fi
echo ""

# Check Waybar process
echo "7. Checking Waybar:"
if pgrep -x "waybar" > /dev/null; then
    echo "   ✅ Waybar is running (PID: $(pgrep -x waybar))"
else
    echo "   ❌ Waybar is NOT running"
    echo "   💡 Try: waybar &"
fi
echo ""

# Test input method status script
echo "8. Testing input method status script:"
if [ -x ~/.config/scripts/input-method-status.sh ]; then
    result=$(~/.config/scripts/input-method-status.sh 2>&1)
    echo "   📊 Status script output: '$result'"
else
    echo "   ❌ Status script not found or not executable"
fi
echo ""

echo "🔧 TROUBLESHOOTING STEPS:"
echo "========================"
echo ""
echo "If IBus daemon is not running:"
echo "  1. Kill any existing IBus processes:"
echo "     pkill -f ibus"
echo "  2. Start IBus daemon:"
echo "     ibus-daemon -drx &"
echo "  3. Wait 2 seconds, then test again"
echo ""
echo "If Bamboo engine not found:"
echo "  1. Check if ibus-bamboo is installed:"
echo "     nix-env -q | grep bamboo"
echo "  2. If not found, rebuild NixOS:"
echo "     sudo nixos-rebuild switch"
echo ""
echo "If environment variables not set:"
echo "  1. Restart your session (logout/login)"
echo "  2. Or manually export them:"
echo "     export GTK_IM_MODULE=ibus"
echo "     export QT_IM_MODULE=ibus"
echo "     export XMODIFIERS=@im=ibus"
echo ""
echo "If Waybar not updating:"
echo "  1. Restart Waybar:"
echo "     pkill waybar && waybar &"
echo "  2. Check if signal is working:"
echo "     pkill -SIGRTMIN+8 waybar"
echo ""
echo "Manual test:"
echo "  1. Open a text editor (gedit, kate, etc.)"
echo "  2. Try typing: tieeng vieejt"
echo "  3. Should become: tiếng việt"
