#!/usr/bin/env bash

echo "🔍 NixOS Fcitx5 Configuration Check"
echo "==================================="
echo ""

# Check if we're on NixOS
if [ ! -f /etc/nixos/configuration.nix ]; then
    echo "❌ Not running on NixOS or configuration.nix not found"
    exit 1
fi

# Check locale.nix configuration
echo "1. Checking locale.nix configuration..."
if [ -f "nixos/locale.nix" ]; then
    echo "   ✅ locale.nix found"

    if grep -q "fcitx5-unikey" nixos/locale.nix; then
        echo "   ✅ fcitx5-unikey found in locale.nix"
    else
        echo "   ❌ fcitx5-unikey NOT found in locale.nix"
    fi

    if grep -q "enabled = \"fcitx5\"" nixos/locale.nix; then
        echo "   ✅ fcitx5 enabled in locale.nix"
    else
        echo "   ❌ fcitx5 NOT enabled in locale.nix"
    fi
else
    echo "   ❌ locale.nix not found"
fi
echo ""

# Check if locale.nix is imported in configuration.nix
echo "2. Checking configuration.nix imports..."
if grep -q "locale.nix" /etc/nixos/configuration.nix; then
    echo "   ✅ locale.nix is imported in configuration.nix"
elif grep -q "./locale.nix" nixos/configuration.nix 2>/dev/null; then
    echo "   ✅ locale.nix is imported in local configuration.nix"
else
    echo "   ❌ locale.nix NOT imported in configuration.nix"
    echo "   💡 This might be the problem!"
fi
echo ""

# Check current system packages
echo "3. Checking current system packages..."
if command -v nix-store >/dev/null 2>&1; then
    if nix-store -q --references /run/current-system 2>/dev/null | grep fcitx5 > /dev/null; then
        echo "   ✅ fcitx5 packages found in current system:"
        nix-store -q --references /run/current-system 2>/dev/null | grep fcitx5 | sed 's/^/      /'
    else
        echo "   ❌ No fcitx5 packages found in current system"
        echo "   💡 Need to rebuild NixOS!"
    fi
else
    echo "   ⚠️  Cannot check nix store"
fi
echo ""

# Check if fcitx5 commands are available
echo "4. Checking fcitx5 availability..."
if command -v fcitx5 >/dev/null 2>&1; then
    echo "   ✅ fcitx5 command available: $(which fcitx5)"
else
    echo "   ❌ fcitx5 command NOT available"
fi

if command -v fcitx5-remote >/dev/null 2>&1; then
    echo "   ✅ fcitx5-remote available: $(which fcitx5-remote)"
else
    echo "   ❌ fcitx5-remote NOT available"
fi
echo ""

# Show current locale.nix content
echo "5. Current locale.nix content:"
if [ -f "nixos/locale.nix" ]; then
    cat nixos/locale.nix | sed 's/^/   /'
else
    echo "   ❌ File not found"
fi
echo ""

echo "🎯 Diagnosis Summary:"
echo "===================="
echo ""
echo "If fcitx5-unikey not in current system:"
echo "   → Run: sudo nixos-rebuild switch"
echo ""
echo "If locale.nix not imported:"
echo "   → Add './locale.nix' to imports in configuration.nix"
echo ""
echo "If configuration looks wrong:"
echo "   → Check locale.nix syntax and content"
