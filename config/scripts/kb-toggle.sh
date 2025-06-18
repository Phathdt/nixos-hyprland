#!/usr/bin/env bash

# Simple keyboard layout toggle
hyprctl switchxkblayout at-translated-set-2-keyboard next

# Show notification
layout=$(hyprctl devices | grep -A 5 "at-translated-set-2-keyboard" | grep "active keymap" | awk '{print $3}')
notify-send "Layout" "Current: $layout" -t 1000
