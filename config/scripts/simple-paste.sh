#!/usr/bin/env bash

# Simple Paste - just send Ctrl+V
if command -v wtype >/dev/null 2>&1; then
    wtype -M ctrl v
elif command -v ydotool >/dev/null 2>&1; then
    ydotool key ctrl+v
fi
