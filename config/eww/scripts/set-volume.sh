#!/usr/bin/env bash

volume=$1
pactl set-sink-volume @DEFAULT_SINK@ "${volume}%"
