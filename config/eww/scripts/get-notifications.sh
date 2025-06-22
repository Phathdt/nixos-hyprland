#!/usr/bin/env bash

notifications=$(swaync-client -j 2>/dev/null)

if [[ -n "$notifications" ]]; then
    echo "$notifications" | jq -r '.data[] | {
        app: .app_name,
        summary: .summary,
        body: .body,
        time: (.time | strftime("%H:%M"))
    }' | jq -s '.'
else
    echo "[]"
fi
