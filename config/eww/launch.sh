#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/eww"

pkill eww
sleep 1

eww daemon --config "$CONFIG_DIR"
