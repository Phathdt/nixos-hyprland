#!/usr/bin/env bash

echo "🔧 fcitx5 Debug Information"
echo "=========================="
echo ""

echo "📋 Process Status:"
if pgrep -f fcitx5 > /dev/null; then
    echo "  ✅ fcitx5 is running"
    echo "  📊 PID: $(pgrep -f fcitx5)"
else
    echo "  ❌ fcitx5 is NOT running"
fi
echo ""

echo "📋 Available Input Methods:"
fcitx5-remote -l 2>/dev/null || echo "  ❌ Cannot list input methods"
echo ""

echo "📋 Current Input Method:"
current_im=$(fcitx5-remote -n 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "  ✅ Current: $current_im"
else
    echo "  ❌ Cannot get current input method"
fi
echo ""

echo "📋 Testing Toggle:"
echo "  🔄 Current state: $(fcitx5-remote -n 2>/dev/null || echo 'unknown')"
echo "  🔄 Trying to toggle..."
fcitx5-remote -t 2>/dev/null
sleep 1
echo "  🔄 New state: $(fcitx5-remote -n 2>/dev/null || echo 'unknown')"
echo ""

echo "📋 Environment Variables:"
echo "  GTK_IM_MODULE: ${GTK_IM_MODULE:-not set}"
echo "  QT_IM_MODULE: ${QT_IM_MODULE:-not set}"
echo "  XMODIFIERS: ${XMODIFIERS:-not set}"
echo ""

echo "📋 Manual Commands:"
echo "  Start fcitx5: fcitx5 -d"
echo "  Toggle: fcitx5-remote -t"
echo "  Set English: fcitx5-remote -s keyboard-us"
echo "  Set Vietnamese: fcitx5-remote -s unikey"
echo "  Current method: fcitx5-remote -n"
