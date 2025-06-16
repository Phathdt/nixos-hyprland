#!/usr/bin/env bash

echo "🔍 Fcitx5 Debug Report"
echo "====================="
echo ""

# Check environment variables
echo "1. Environment Variables:"
echo "   GTK_IM_MODULE: ${GTK_IM_MODULE:-not set}"
echo "   QT_IM_MODULE: ${QT_IM_MODULE:-not set}"
echo "   XMODIFIERS: ${XMODIFIERS:-not set}"
echo "   INPUT_METHOD: ${INPUT_METHOD:-not set}"
echo ""

# Check if fcitx5 is running
echo "2. Process Status:"
if pgrep -x "fcitx5" > /dev/null; then
    echo "   ✅ Fcitx5 is running (PID: $(pgrep -x fcitx5))"
else
    echo "   ❌ Fcitx5 is NOT running"
fi
echo ""

# Check available input methods
echo "3. Available Input Methods:"
fcitx5-remote -l 2>/dev/null | while read -r line; do
    echo "   📝 $line"
done
echo ""

# Check current input method
echo "4. Current Input Method:"
current_im=$(fcitx5-remote -n 2>/dev/null)
if [ -n "$current_im" ]; then
    echo "   📍 Current: $current_im"
else
    echo "   ⚠️  No current input method"
fi
echo ""

# Check fcitx5 configuration directory
echo "5. Configuration Files:"
config_dir="$HOME/.config/fcitx5"
if [ -d "$config_dir" ]; then
    echo "   📁 Config directory exists: $config_dir"
    if [ -f "$config_dir/profile" ]; then
        echo "   📄 Profile file exists"
        echo "   Content:"
        cat "$config_dir/profile" | sed 's/^/      /'
    else
        echo "   ⚠️  No profile file found"
    fi
else
    echo "   ❌ Config directory does not exist: $config_dir"
fi
echo ""

# Check if unikey addon is available
echo "6. Unikey Addon Check:"
if fcitx5-remote -l 2>/dev/null | grep -i unikey > /dev/null; then
    echo "   ✅ Unikey is available in input method list"
else
    echo "   ❌ Unikey NOT found in input method list"
    echo "   💡 This might be the problem!"
fi
echo ""

# Test switching to unikey
echo "7. Switch Test:"
echo "   Testing switch to unikey..."
if fcitx5-remote -s unikey 2>/dev/null; then
    echo "   ✅ Switch command succeeded"
    sleep 1
    new_im=$(fcitx5-remote -n 2>/dev/null)
    echo "   📍 After switch: $new_im"
else
    echo "   ❌ Switch command failed"
fi
echo ""

# Check system packages
echo "8. System Package Check:"
if command -v nix-store >/dev/null 2>&1; then
    echo "   Checking for fcitx5-unikey in nix store..."
    if nix-store -q --references /run/current-system 2>/dev/null | grep fcitx5-unikey > /dev/null; then
        echo "   ✅ fcitx5-unikey found in system"
    else
        echo "   ❌ fcitx5-unikey NOT found in system"
        echo "   💡 Make sure you've rebuilt NixOS!"
    fi
else
    echo "   ⚠️  Cannot check nix store"
fi
echo ""

# Check desktop environment
echo "9. Desktop Environment:"
echo "   XDG_CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP:-not set}"
echo "   WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"
echo "   DISPLAY: ${DISPLAY:-not set}"
echo ""

echo "🎯 Debug Summary:"
echo "================"
echo ""
echo "Common issues and solutions:"
echo "1. If Unikey not in list → Rebuild NixOS with fcitx5-unikey"
echo "2. If environment vars not set → Restart session after rebuild"
echo "3. If config missing → Run fcitx5-configtool to setup"
echo "4. If switch fails → Check addon installation"
echo ""
echo "Next steps:"
echo "- If Unikey missing: sudo nixos-rebuild switch"
echo "- If env vars missing: logout/login or reboot"
echo "- If config missing: fcitx5-configtool"
