#!/usr/bin/env bash

if [[ ! -f "$HOME/.config/sketchybar/colors.sh" ]]; then
    return
fi

source "$HOME/.config/sketchybar/colors.sh"

# Ref: https://github.com/cauliyang/dotfiles/blob/main/dot_config/skhd/executable_mode_controller.sh
case "$1" in
default)
  sketchybar  --trigger mode_changed                           \
              --set mode_indicator drawing=off                 \
              --set mode_indicator label=""
  ;;
display)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[DISPLAY]"           \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
spc)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[SPACE]"             \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
stack)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[STACK]"             \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
window)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[WINDOW]"            \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
resize)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[RESIZE]"            \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
inst)
  sketchybar  --set mode_indicator drawing=on                  \
              --set mode_indicator label="[INSERT]"            \
              --set mode_indicator background.color=$RED       \
              --set mode_indicator background.corner_radius=0  \
              --set mode_indicator label.color=$WHITE
  ;;
esac
