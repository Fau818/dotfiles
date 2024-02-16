#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
WIFI_ERROR=􀙥


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Bold:14.0"
LABEL_FONT="$FONT:Semibold:13.0"


# -----------------------------------
# -------- Scripts
# -----------------------------------
OPEN_WIFI_PREFERENCE='open x-apple.systempreferences:com.apple.preference.network?Wi-Fi'


# -----------------------------------
# -------- Preferences
# -----------------------------------
wifi=(
  update_freq=0  # NOTE: Managed in script.
  script="$SCRIPT_DIR/wifi.sh"
  click_script="$OPEN_WIFI_PREFERENCE"
  padding_right="$ITEM_MARGIN"
  padding_left="$ITEM_MARGIN"  # NOTE: Margin for `app`

  icon="$WIFI_ERROR"
  icon.font="$ICON_FONT"
  icon.color="$RED"
  icon.padding_left="$BACKGROUND_MARGIN"

  label='??? ?B/s'
  label.font="$LABEL_FONT"
  label.color="$RED"
  label.padding_right="$BACKGROUND_MARGIN"
  label.width=65
  label.align=center

  background.color="$BACKGROUND_COLOR"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  wifi right        \
           --set       wifi "${wifi[@]}" \
           --subscribe wifi wifi_change
