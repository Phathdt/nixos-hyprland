#!/usr/bin/env bash

# Launch Chrome with optimal flags for crisp text on scaled displays

exec google-chrome-stable \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --enable-wayland-ime \
    --force-device-scale-factor=1 \
    --high-dpi-support=1 \
    --disable-features=WaylandFractionalScaleV1 \
    --enable-features=WebRTCPipeWireCapturer \
    "$@"
