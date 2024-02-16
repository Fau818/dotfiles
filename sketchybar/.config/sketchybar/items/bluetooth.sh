#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
BLUETOOTH=


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$NERD_FONT:Bold:14.0"
LABEL_FONT="$NERD_FONT:Bold:14.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
bluetooth=(
  update_freq=0
  script="$SCRIPT_DIR/bluetooth.sh"
  click_script="$SCRIPT_DIR/click/bluetooth.sh"
  padding_right="$ITEM_MARGIN"

  icon="$BLUETOOTH"
  icon.font="$ICON_FONT"
  icon.color="$BLUE"
  icon.padding_left="$BACKGROUND_MARGIN"

  label='?'
  label.font="$LABEL_FONT"
  label.color="$BLUE"
  label.padding_right="$BACKGROUND_MARGIN"

  background.color="$BACKGROUND_COLOR"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
# NOTE: Do not use the `com.apple.bluetooth.status` event since it updates frequently.
sketchybar --add item  bluetooth right \
           --set       bluetooth "${bluetooth[@]}" \
           --subscribe bluetooth bluetooth_on bluetooth_off
