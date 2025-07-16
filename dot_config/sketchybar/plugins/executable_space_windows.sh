#!/usr/bin/env bash

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    prevapps=$(aerospace list-windows --format %{app-name} --workspace "$PREV_WORKSPACE" | sort -u)
    if [ "${prevapps}" != "" ]; then
        icon_strip=""
        while read -r app
        do
            icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
        done <<< "${prevapps}"
        sketchybar --set space."$PREV_WORKSPACE" label="$icon_strip" drawing=on
    else
        sketchybar --set space."$PREV_WORKSPACE" drawing=off
    fi
else
    FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"
fi

apps=$(aerospace list-windows --format %{app-name} --workspace "$FOCUSED_WORKSPACE" | sort -u)
icon_strip=""
if [ "${apps}" != "" ]; then
    while read -r app
    do
        icon_strip+=" $("$CONFIG_DIR"/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
else
    icon_strip="—"
fi

sketchybar --set space."$FOCUSED_WORKSPACE" label="$icon_strip" drawing=on
