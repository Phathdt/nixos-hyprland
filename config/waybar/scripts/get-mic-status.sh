#!/usr/bin/env bash

# Get microphone status
mic_muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes" && echo "true" || echo "false")

if [[ "$mic_muted" == "true" ]]; then
    icon="󰍭"
    class="muted"
    tooltip="Microphone Muted (Click to unmute)"
else
    icon="󰍬"
    class="active"
    tooltip="Microphone Active (Click to mute)"
fi

echo "{\"text\":\"$icon\", \"class\":\"$class\", \"tooltip\":\"$tooltip\"}"
