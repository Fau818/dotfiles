#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
OPEN_MISSION_CONTROL="open -a 'Mission Control'"


# -----------------------------------
# -------- Fields
# -----------------------------------
LABEL_FONT="$FONT:Heavy:12.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
front_app=(
  update_freq=0
  display=active
  script="$SCRIPT_DIR/front_app.sh"
  click_script="$OPEN_MISSION_CONTROL"
  padding_left="$ITEM_MARGIN"

  icon.background.drawing=on
  label.font="$LABEL_FONT"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  front_app left              \
           --set       front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched
