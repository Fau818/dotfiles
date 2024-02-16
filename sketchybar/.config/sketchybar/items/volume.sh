#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
KNOB=􀀁
VOLUME_ERROR=􀾐


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Heavy:13.0"
LABEL_FONT="$FONT:Heavy:11.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
volume_slider=(
  update_freq=0
  click_script="$SCRIPT_DIR/click/volume_slider.sh"

  icon.drawing=off
  label.drawing=off

  slider.width=0
  slider.percentage=0
  slider.highlight_color="$MAGENTA"

  slider.knob.drawing=off
  slider.knob="$KNOB"
  slider.knob.font="$ICON_FONT"

  slider.background.height=5.8
  slider.background.corner_radius=100
  slider.background.color="$WHITE"
)

volume=(
  update_freq=0
  script="$SCRIPT_DIR/volume.sh"
  click_script="$SCRIPT_DIR/click/volume.sh"

  icon="$VOLUME_ERROR"
  icon.font="$ICON_FONT"
  icon.color="$MAGENTA"
  icon.padding_left="$BACKGROUND_MARGIN"

  label='??%'
  label.font="$LABEL_FONT"
  label.color="$MAGENTA"
  label.padding_right="$BACKGROUND_MARGIN"
)

volume_bracket=(
  background.color=$BACKGROUND_COLOR
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add slider  volume_slider right                       \
           --set         volume_slider "${volume_slider[@]}"       \
           \
           --add item    volume right          \
           --set         volume "${volume[@]}" \
           --subscribe   volume volume_change  \
           \
           --add bracket volume_bracket volume volume_slider \
           --set         volume_bracket "${volume_bracket[@]}"
