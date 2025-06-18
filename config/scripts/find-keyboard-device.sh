#!/usr/bin/env bash

echo "=== All Keyboard Devices ==="
hyprctl devices | grep -A 20 "Keyboard"

echo ""
echo "=== Keyboard Device Names ==="
hyprctl devices | grep -B 2 -A 5 "Keyboard" | grep "^[[:space:]]*[^[:space:]]" | head -10

echo ""
echo "=== Testing layout switch commands ==="
echo "Available keyboards:"
hyprctl devices | grep -B 1 -A 1 "Keyboard" | grep -E "^[[:space:]]*[^[:space:]]|main: yes"
