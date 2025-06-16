#!/usr/bin/env bash

echo "🔧 Setting up Fcitx5 Configuration"
echo "=================================="
echo ""

# Create config directory
config_dir="$HOME/.config/fcitx5"
echo "1. Creating config directory..."
mkdir -p "$config_dir"
echo "   ✅ Directory created: $config_dir"
echo ""

# Create profile file
echo "2. Creating profile configuration..."
cat > "$config_dir/profile" << 'EOF'
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=keyboard-us

[Groups/0/Items/0]
# Name
Name=keyboard-us
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=unikey
# Layout
Layout=

[GroupOrder]
0=Default
EOF

echo "   ✅ Profile file created"
echo ""

# Create config file
echo "3. Creating main configuration..."
cat > "$config_dir/config" << 'EOF'
[Hotkey]
# Enumerate when press trigger key repeatedly
EnumerateWithTriggerKeys=True
# Temporally switch between first and current Input Method
AltTriggerKeys=
# Enumerate Input Method Forward
EnumerateForwardKeys=
# Enumerate Input Method Backward
EnumerateBackwardKeys=
# Skip first input method while enumerating
EnumerateSkipFirst=False
# Enumerate Input Method Group Forward
EnumerateGroupForwardKeys=
# Enumerate Input Method Group Backward
EnumerateGroupBackwardKeys=
# Activate Input Method
ActivateKeys=
# Deactivate Input Method
DeactivateKeys=
# Toggle Input Method
TriggerKeys=Control+space

[Hotkey/PrevPage]
0=Up

[Hotkey/NextPage]
0=Down

[Hotkey/PrevCandidate]
0=Shift+Tab

[Hotkey/NextCandidate]
0=Tab

[Behavior]
# Active By Default
ActiveByDefault=False
# Share Input State
ShareInputState=No
# Show preedit in application
PreeditEnabledByDefault=True
# Show Input Method Information when switch input method
ShowInputMethodInformation=True
# Show Input Method Information when changing focus
ShowInputMethodInformationWhenFocusIn=False
# Show compact input method information
CompactInputMethodInformation=True
# Show first input method information
ShowFirstInputMethodInformation=True
# Default page size
DefaultPageSize=5
# Override Xkb Option
OverrideXkbOption=False
# Custom Xkb Option
CustomXkbOption=
# Force Enabled Addons
EnabledAddons=
# Force Disabled Addons
DisabledAddons=
# Preload input method to be used by default
PreloadInputMethod=True
# Allow input method override system XKB settings
AllowInputMethodForPassword=False
# Show preedit text when typing password
ShowPreeditForPassword=False
# Interval of saving user data in minutes
AutoSavePeriod=30
EOF

echo "   ✅ Main config file created"
echo ""

# Restart fcitx5
echo "4. Restarting Fcitx5..."
pkill -f fcitx5 2>/dev/null || true
sleep 2
fcitx5 -d &
sleep 3

if pgrep -x "fcitx5" > /dev/null; then
    echo "   ✅ Fcitx5 restarted successfully"
else
    echo "   ❌ Failed to restart Fcitx5"
fi
echo ""

# Test configuration
echo "5. Testing configuration..."
echo "   Available input methods:"
fcitx5-remote -l 2>/dev/null | while read -r line; do
    echo "      📝 $line"
done

current_im=$(fcitx5-remote -n 2>/dev/null)
echo "   📍 Current input method: ${current_im:-none}"
echo ""

echo "🎯 Configuration Complete!"
echo "========================="
echo ""
echo "Next steps:"
echo "1. Test switching: fcitx5-remote -s unikey"
echo "2. Test toggle: fcitx5-remote -t"
echo "3. Open text editor and try typing"
echo "4. Use Ctrl+Space to toggle input methods"
