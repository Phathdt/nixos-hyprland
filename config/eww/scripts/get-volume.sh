#!/usr/bin/env bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
echo "$volume"
