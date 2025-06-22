#!/usr/bin/env bash

muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -o "yes")
if [ "$muted" = "yes" ]; then
    echo "true"
else
    echo "false"
fi
