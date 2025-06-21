#!/usr/bin/env bash

status=$(nmcli radio wifi)
if [ "$status" = "enabled" ]; then
    echo "enabled"
else
    echo "disabled"
fi
