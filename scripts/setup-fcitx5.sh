#!/usr/bin/env bash

echo "Setting up fcitx5 Vietnamese input method..."

# Start fcitx5 daemon
fcitx5 -d

# Wait a moment for the daemon to start
sleep 2

# Add Unikey input method
fcitx5-remote -r
fcitx5-configtool &

echo "fcitx5 daemon started and configuration tool opened."
echo ""
echo "Manual steps to complete setup:"
echo "1. In the fcitx5 configuration window:"
echo "   - Click 'Add input method'"
echo "   - Search for 'Unikey' or 'Vietnamese'"
echo "   - Add 'Vietnamese (Unikey)'"
echo "   - Configure hotkeys as desired"
echo ""
echo "2. Test Vietnamese input with Ctrl+Space to switch input methods"
echo ""
echo "3. To start fcitx5 automatically, it should start with your desktop session"
echo "   If not, add 'fcitx5 -d' to your autostart"

# Make fcitx5 start automatically by adding to autostart
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/fcitx5.desktop << 'EOF'
[Desktop Entry]
Name=Fcitx5
GenericName=Input Method
Comment=Start Input Method
Exec=fcitx5 -d
Icon=fcitx
Terminal=false
Type=Application
Categories=System;Utility;
StartupNotify=false
EOF

echo ""
echo "fcitx5 autostart entry created at ~/.config/autostart/fcitx5.desktop"
