#!/usr/bin/env bash

current_player=$(playerctl -l 2>/dev/null | grep -E 'spotify|firefox|brave|chromium' | while read player; do
    player_name=$(echo "$player" | sed 's/\..*//')
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
        echo "$player_name"
        break
    fi
done)

if [[ -n "$current_player" ]]; then
    status=$(playerctl -p "$current_player" status 2>/dev/null)
    title=$(playerctl -p "$current_player" metadata title 2>/dev/null)
    artist=$(playerctl -p "$current_player" metadata artist 2>/dev/null)
    artUrl=$(playerctl -p "$current_player" metadata mpris:artUrl 2>/dev/null)

    if [[ "$current_player" == "spotify" ]]; then
        icon=""
        app="Spotify"
    elif [[ "$current_player" == "firefox" || "$current_player" == "brave" || "$current_player" == "chromium" ]]; then
        icon=""
        app="Browser"
    else
        icon=""
        app="Music"
    fi

    playing="false"
    if [[ "$status" == "Playing" ]]; then
        playing="true"
    fi

    if [[ -z "$title" ]]; then
        title="Unknown"
    fi
    if [[ -z "$artist" ]]; then
        artist="Unknown Artist"
    fi
    if [[ -z "$artUrl" ]]; then
        artUrl=""
    fi

    echo "{\"playing\": $playing, \"title\": \"$title\", \"artist\": \"$artist\", \"app\": \"$app\", \"icon\": \"$icon\", \"artUrl\": \"$artUrl\"}"
else
    echo "{\"playing\": false, \"title\": \"\", \"artist\": \"\", \"app\": \"\", \"icon\": \"\", \"artUrl\": \"\"}"
fi
