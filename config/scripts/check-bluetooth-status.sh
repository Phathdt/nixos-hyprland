#!/usr/bin/env bash

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$status" = "yes" ]; then
    echo "enabled"
else
    echo "disabled"
fi
