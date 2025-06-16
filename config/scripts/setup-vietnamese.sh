#!/usr/bin/env bash

# Setup IBus preferences for Vietnamese typing
echo "Setting up Vietnamese input method..."

# Start IBus daemon if not running
if ! pgrep -x "ibus-daemon" > /dev/null; then
    echo "Starting IBus daemon..."
    ibus-daemon -drx &
    sleep 2
fi

# Add Bamboo engine
echo "Adding Bamboo engine..."
ibus engine Bamboo 2>/dev/null || echo "Bamboo engine not found, will be available after NixOS rebuild"

# Set IBus preferences
echo "Configuring IBus preferences..."
gsettings set org.freedesktop.ibus.general preload-engines "['xkb:us::eng', 'Bamboo']"
gsettings set org.freedesktop.ibus.general engines-order "['xkb:us::eng', 'Bamboo']"
gsettings set org.freedesktop.ibus.general use-system-keyboard-layout false
gsettings set org.freedesktop.ibus.general use-global-engine true

# Configure Bamboo engine settings (if available)
if ibus list-engine | grep -q "Bamboo"; then
    echo "Configuring Bamboo engine..."
    # Set default input method to Telex
    gsettings set org.freedesktop.ibus.engine.bamboo input-method 0
    # Enable spell checking
    gsettings set org.freedesktop.ibus.engine.bamboo enable-spell-check true
    # Set output charset to Unicode
    gsettings set org.freedesktop.ibus.engine.bamboo output-charset 0
fi

echo "Vietnamese input method setup completed!"
echo ""
echo "Usage:"
echo "  - Super + I: Toggle between English and Vietnamese"
echo "  - Alt + Shift: Alternative toggle shortcut"
echo ""
echo "After NixOS rebuild, restart your session for full functionality."
