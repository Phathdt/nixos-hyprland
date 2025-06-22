#!/usr/bin/env bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

if [ "$muted" = "yes" ]; then
    echo "󰝟"
elif [ "$volume" -eq 0 ]; then
    echo "󰕿"
elif [ "$volume" -le 33 ]; then
    echo "󰖀"
elif [ "$volume" -le 66 ]; then
    echo "󰕾"
else
    echo "󰕾"
fi
