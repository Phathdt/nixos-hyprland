#!/usr/bin/env bash

# Smart Copy Script
# Copies selected text if available, otherwise sends Ctrl+C to copy

if command -v wtype >/dev/null 2>&1; then
    # Send Ctrl+C to the active window to copy selection
    wtype -M ctrl c

    # Wait a moment for the copy to complete
    sleep 0.1

    # Verify something was copied
    if command -v wl-paste >/dev/null 2>&1; then
        CLIPBOARD_CONTENT=$(wl-paste 2>/dev/null)
        if [ -n "$CLIPBOARD_CONTENT" ]; then
            # Successfully copied
            exit 0
        fi
    fi
fi

# Fallback: try direct clipboard copy
if command -v wl-copy >/dev/null 2>&1; then
    wl-copy
fi
