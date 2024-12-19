#!/usr/bin/env bash

if [ "$SENDER" = "space_windows_change" ]; then
    sid="$(aerospace list-workspaces --focused)"
    apps="$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | sort -u)"

    icon_strip=" "
    if [ "${apps}" != "" ]; then
        while read -r app
        do
            icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
        done <<< "${apps}"
    else
        icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
fi
