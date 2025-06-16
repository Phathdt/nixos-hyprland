#!/usr/bin/env bash

echo "🔍 Simple IBus Test"
echo "=================="
echo ""

# Step 1: Check if ibus command exists
echo "Step 1: Checking IBus installation..."
if command -v ibus >/dev/null 2>&1; then
    echo "✅ IBus command found: $(which ibus)"
else
    echo "❌ IBus command not found"
    exit 1
fi

# Step 2: Kill existing processes
echo ""
echo "Step 2: Cleaning up existing IBus processes..."
pkill -f ibus 2>/dev/null || true
sleep 1
echo "✅ Cleanup done"

# Step 3: Start daemon (non-blocking)
echo ""
echo "Step 3: Starting IBus daemon..."
ibus-daemon -d --replace &
DAEMON_PID=$!
echo "✅ IBus daemon started (PID: $DAEMON_PID)"

# Step 4: Wait and check if daemon is running
echo ""
echo "Step 4: Waiting for daemon to initialize..."
sleep 3

if pgrep -x "ibus-daemon" > /dev/null; then
    echo "✅ IBus daemon is running"
else
    echo "❌ IBus daemon not running"
    exit 1
fi

# Step 5: Test connection with timeout
echo ""
echo "Step 5: Testing IBus connection..."
timeout 10 ibus list-engine > /tmp/ibus-engines.txt 2>&1
if [ $? -eq 0 ]; then
    echo "✅ IBus connection successful"
    echo "📋 Available engines:"
    head -10 /tmp/ibus-engines.txt | sed 's/^/   /'

    # Check for Bamboo
    if grep -qi bamboo /tmp/ibus-engines.txt; then
        echo ""
        echo "✅ Bamboo engines found:"
        grep -i bamboo /tmp/ibus-engines.txt | sed 's/^/   /'
    else
        echo ""
        echo "❌ No Bamboo engines found"
    fi
else
    echo "❌ Cannot connect to IBus (timeout or error)"
    echo "Error output:"
    cat /tmp/ibus-engines.txt | sed 's/^/   /'
fi

# Cleanup
rm -f /tmp/ibus-engines.txt

echo ""
echo "Test completed!"
