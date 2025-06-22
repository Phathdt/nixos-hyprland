#!/usr/bin/env bash

if eww windows | grep -q "settings-panel"; then
    eww close settings-panel
else
    eww open settings-panel
fi
