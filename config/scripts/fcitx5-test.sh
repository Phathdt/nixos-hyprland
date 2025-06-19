#!/usr/bin/env bash

echo "🧪 fcitx5 Environment Test"
echo "========================="
echo ""

echo "📋 Environment Variables:"
echo "  GTK_IM_MODULE: ${GTK_IM_MODULE:-❌ NOT SET}"
echo "  QT_IM_MODULE: ${QT_IM_MODULE:-❌ NOT SET}"
echo "  XMODIFIERS: ${XMODIFIERS:-❌ NOT SET}"
echo ""

echo "📋 fcitx5 Status:"
if pgrep -f fcitx5 > /dev/null; then
    echo "  ✅ fcitx5 is running (PID: $(pgrep -f fcitx5))"
else
    echo "  ❌ fcitx5 is NOT running"
fi

echo "  fcitx5-remote status: $(fcitx5-remote 2>/dev/null || echo '❌ failed')"
echo "  Current input method: $(fcitx5-remote -n 2>/dev/null || echo '❌ unknown')"
echo ""

echo "📋 Available Input Methods:"
fcitx5-remote -l 2>/dev/null || echo "  ❌ Cannot list input methods"
echo ""

echo "🔄 Testing Input Method Switch:"
echo "  Current: $(fcitx5-remote -n 2>/dev/null)"

echo "  Setting to English..."
fcitx5-remote -s keyboard-us
sleep 1
echo "  Result: $(fcitx5-remote -n 2>/dev/null)"

echo "  Setting to Vietnamese..."
fcitx5-remote -s unikey
sleep 1
current=$(fcitx5-remote -n 2>/dev/null)
echo "  Result: $current"

if [ "$current" = "unikey" ]; then
    echo "  ✅ SUCCESS: Vietnamese input method is working!"
    notify-send -i "input-keyboard" -t 2000 "fcitx5 Test" "✅ Vietnamese input is working!"
else
    echo "  ❌ FAILED: Cannot switch to Vietnamese input"
    notify-send -i "dialog-error" -t 2000 "fcitx5 Test" "❌ Vietnamese input switch failed"
fi

echo ""
echo "📋 Desktop Session Info:"
echo "  XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-not set}"
echo "  WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"
echo "  DISPLAY: ${DISPLAY:-not set}"
echo ""

echo "🎯 Next Steps:"
if [ "$current" = "unikey" ]; then
    echo "  ✅ Environment is configured correctly"
    echo "  ✅ Try typing Vietnamese in any application"
    echo "  ✅ Use Super+I or click waybar to toggle"
else
    echo "  🔄 Restart Hyprland session to apply environment variables"
    echo "  🔄 Or run: source ~/.config/hypr/modules/environment.conf"
fi
