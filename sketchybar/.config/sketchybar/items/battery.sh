#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
BATTERY_CLICK_SCRIPT='open x-apple.systempreferences:com.apple.preference.battery'


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Medium:17.5"
LABEL_FONT="$FONT:Bold:12.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
battery=(
  update_freq=120
  script="$SCRIPT_DIR/battery.sh"
  click_script="$BATTERY_CLICK_SCRIPT"
  padding_right="$ITEM_MARGIN"
  padding_left="$ITEM_MARGIN"  # NOTE: Margin for `volume`

  icon.font="$ICON_FONT"
  icon.y_offset=1

  label.font="$LABEL_FONT"
  label.y_offset=1

  icon.padding_left="$BACKGROUND_MARGIN"
  label.padding_right="$BACKGROUND_MARGIN"
  background.color="$BACKGROUND_COLOR"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  battery right \
           --set       battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke
