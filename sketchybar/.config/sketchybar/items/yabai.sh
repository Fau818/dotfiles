#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
ERROR_ICON=􀏎


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Bold:14.0"
LABEL_FONT="$FONT:Semibold:11.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
yabai=(
  update_freq=0
  display=active
  script="$SCRIPT_DIR/yabai.sh"
  padding_left="$ITEM_MARGIN"

  icon="$ERROR_ICON"
  icon.font="$ICON_FONT"
  icon.color="$RED"

  label='ERROR'
  label.font="$LABEL_FONT"
  label.color="$RED"
  label.y_offset=5
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  yabai left          \
           --set       yabai "${yabai[@]}" \
           --subscribe yabai skhd_space_type_changed skhd_window_type_changed yabai_window_focused yabai_loaded
