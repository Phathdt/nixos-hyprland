#!/usr/bin/env bash

echo "🔍 Checking Fcitx5-Unikey Installation"
echo "======================================"
echo ""

# Method 1: Check nix-store for fcitx5-unikey
echo "1. Checking nix store for fcitx5-unikey..."
if nix-store -q --references /run/current-system 2>/dev/null | grep -i unikey; then
    echo "   ✅ fcitx5-unikey found in current system:"
    nix-store -q --references /run/current-system 2>/dev/null | grep -i unikey | sed 's/^/      /'
else
    echo "   ❌ fcitx5-unikey NOT found in current system"
fi
echo ""

# Method 2: Check if unikey files exist in nix store
echo "2. Searching for unikey files in nix store..."
if find /nix/store -name "*unikey*" -type d 2>/dev/null | head -5; then
    echo "   ✅ Unikey directories found in nix store"
else
    echo "   ❌ No unikey directories found"
fi
echo ""

# Method 3: Check available packages
echo "3. Checking if fcitx5-unikey package exists..."
if nix-env -qa | grep fcitx5-unikey; then
    echo "   ✅ fcitx5-unikey package is available"
else
    echo "   ❌ fcitx5-unikey package not found"
fi
echo ""

# Method 4: Check system packages
echo "4. Checking system packages..."
if nix-store -q --references /run/current-system | grep fcitx5 | head -10; then
    echo "   ✅ Fcitx5 packages found:"
    nix-store -q --references /run/current-system | grep fcitx5 | sed 's/^/      /'
else
    echo "   ❌ No fcitx5 packages found in system"
fi
echo ""

# Method 5: Check if fcitx5 commands are available
echo "5. Checking fcitx5 commands..."
if command -v fcitx5 >/dev/null 2>&1; then
    echo "   ✅ fcitx5 command: $(which fcitx5)"
    fcitx5 --version 2>/dev/null | head -1 | sed 's/^/      /'
else
    echo "   ❌ fcitx5 command not found"
fi

if command -v fcitx5-remote >/dev/null 2>&1; then
    echo "   ✅ fcitx5-remote: $(which fcitx5-remote)"
else
    echo "   ❌ fcitx5-remote not found"
fi

if command -v fcitx5-configtool >/dev/null 2>&1; then
    echo "   ✅ fcitx5-configtool: $(which fcitx5-configtool)"
else
    echo "   ❌ fcitx5-configtool not found"
fi
echo ""

# Method 6: Test if we can start fcitx5 and list addons
echo "6. Testing fcitx5 functionality..."
if command -v fcitx5 >/dev/null 2>&1; then
    # Kill existing fcitx5
    pkill -f fcitx5 2>/dev/null || true
    sleep 1

    # Start fcitx5
    fcitx5 -d &
    sleep 3

    if pgrep -x "fcitx5" > /dev/null; then
        echo "   ✅ Fcitx5 started successfully"

        # List available input methods
        echo "   📝 Available input methods:"
        fcitx5-remote -l 2>/dev/null | sed 's/^/      /' || echo "      ❌ Cannot list input methods"

        # Check for unikey specifically
        if fcitx5-remote -l 2>/dev/null | grep -i unikey > /dev/null; then
            echo "   ✅ Unikey found in input method list!"
        else
            echo "   ❌ Unikey NOT found in input method list"
        fi
    else
        echo "   ❌ Failed to start fcitx5"
    fi
else
    echo "   ❌ Cannot test - fcitx5 command not available"
fi
echo ""

# Method 7: Check configuration
echo "7. Checking NixOS configuration..."
if [ -f "nixos/locale.nix" ]; then
    echo "   📄 locale.nix content:"
    grep -A 10 "i18n.inputMethod" nixos/locale.nix | sed 's/^/      /'
else
    echo "   ❌ locale.nix not found"
fi
echo ""

echo "🎯 Installation Status Summary:"
echo "==============================="
echo ""
if nix-store -q --references /run/current-system 2>/dev/null | grep -i unikey > /dev/null; then
    echo "✅ fcitx5-unikey IS installed in the system"
    echo "   → Problem might be configuration or environment"
    echo "   → Try: logout/login or reboot"
else
    echo "❌ fcitx5-unikey is NOT installed in the system"
    echo "   → Need to rebuild NixOS"
    echo "   → Run: sudo nixos-rebuild switch"
    echo "   → Check for build errors"
fi
