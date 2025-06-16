#!/usr/bin/env bash

# Smart Paste Script
# Pastes clipboard content to active window

if command -v wl-paste >/dev/null 2>&1; then
    # Get clipboard content
    CLIPBOARD_CONTENT=$(wl-paste 2>/dev/null)

    if [ -n "$CLIPBOARD_CONTENT" ]; then
        # Try to paste using wtype
        if command -v wtype >/dev/null 2>&1; then
            wtype -M ctrl v
        else
            # Fallback: type the content directly
            echo "$CLIPBOARD_CONTENT" | wtype -
        fi
    fi
fi
