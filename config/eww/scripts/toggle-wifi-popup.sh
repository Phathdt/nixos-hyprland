#!/bin/bash

if eww windows | grep -q "wifi-popup-window"; then
    eww close wifi-popup-window
else
    eww open wifi-popup-window
fi
