#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
OPEN_CALENDAR='open -a Calendar'


# -----------------------------------
# -------- Icons
# -----------------------------------
CALENDAR=􀉉
# CLOCK=􀐫


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Bold:13.0"
LABEL_FONT="$FONT:Semibold:13.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
calendar=(
  update_freq=0
  script="$SCRIPT_DIR/calendar.sh"
  click_script="$OPEN_CALENDAR"
  mach_helper="$HELPER"

  icon="$CALENDAR Loading..."
  icon.font="$ICON_FONT"
  icon.color="$YELLOW"
  icon.padding_left="$BACKGROUND_MARGIN"
  icon.padding_right=5  # NOTE: Add gap between date and time.

  label="$CLOCK Loading..."
  label.font="$LABEL_FONT"
  label.color="$WHITE"
  label.padding_right="$BACKGROUND_MARGIN"
  label.width=65
  label.align=right

  background.color="$BACKGROUND_COLOR"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  calendar right \
           --set       calendar "${calendar[@]}"
