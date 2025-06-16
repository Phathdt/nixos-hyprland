#!/usr/bin/env bash

# Simple Copy - just send Ctrl+C
if command -v wtype >/dev/null 2>&1; then
    wtype -M ctrl c
elif command -v ydotool >/dev/null 2>&1; then
    ydotool key ctrl+c
fi
