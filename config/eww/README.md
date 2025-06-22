# EWW Settings Panel

A custom settings panel built with EWW that replaces the swaync settings panel in Waybar.

## Features

- **Power Controls**: Shutdown, Lock, and Do Not Disturb buttons
- **Connectivity**: Wi-Fi and Bluetooth status with toggle functionality
- **Audio Controls**: Microphone toggle and volume slider
- **Music Player**: Shows currently playing music with playback controls
- **Notifications**: Display and manage system notifications

## Design

The panel follows the Material Palenight color scheme to match the overall system theme.

## Setup

1. Install EWW (Elkowar's Wacky Widgets)
2. Launch the EWW daemon:
   ```bash
   ./config/eww/launch.sh
   ```
3. The panel can be toggled from Waybar or manually:
   ```bash
   ./config/eww/scripts/toggle-settings-panel.sh
   ```

## Dependencies

- `eww` - The widget system
- `nmcli` - Network management
- `bluetoothctl` - Bluetooth management
- `pactl` - PulseAudio control
- `playerctl` - Media player control
- `swaync-client` - Notification management
- `jq` - JSON processing

## Scripts

All scripts are located in `scripts/` directory:
- `get-wifi-status.sh` - Get Wi-Fi connection status
- `get-bluetooth-status.sh` - Get Bluetooth connection status
- `get-volume.sh` - Get current volume level
- `get-volume-icon.sh` - Get appropriate volume icon
- `get-mic-status.sh` - Get microphone mute status
- `toggle-mic.sh` - Toggle microphone mute
- `set-volume.sh` - Set volume level
- `get-music-info.sh` - Get current music player information
- `get-notifications.sh` - Get system notifications
- `toggle-settings-panel.sh` - Toggle the settings panel

## Customization

The panel styling can be customized by editing `eww.scss`. The Material Palenight color variables are defined at the top of the file.
