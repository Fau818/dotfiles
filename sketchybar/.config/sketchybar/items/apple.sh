#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
APPLE=􀣺
PREFERENCES=􀺽
ACTIVITY=􀒓
LOCK=􀒳


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Bold:18.0"
LABEL_FONT="$NERD_FONT:Regular:22.0"
POPUP_LABEL_FONT="$FONT:Semibold:13.0"


# -----------------------------------
# -------- Scripts
# -----------------------------------
POPUP_OFF='sketchybar --set apple popup.drawing=off'
POPUP_CLICK_SCRIPT='sketchybar --set apple popup.drawing=toggle'


# -----------------------------------
# -------- Preferences
# -----------------------------------
apple=(
  click_script="$POPUP_CLICK_SCRIPT"

  icon="$APPLE"
  icon.font="$ICON_FONT"
  icon.color="$BLUE"
  icon.padding_right=10
  icon.y_offset=1

  # label.font="$LABEL_FONT"
  # label.padding_left=$BACKGROUND_MARGIN
  # label.y_offset=2  # For better vertical alignment

  label.background.drawing=on
  label.background.image="$CONFIG_DIR/assert/seperator.png"
  label.background.image.scale=0.10
  label.padding_right="$BACKGROUND_MARGIN"
)

apple_prefs=(
  update_freq=0
  click_script="open -a 'System Preferences'; $POPUP_OFF"

  icon="$PREFERENCES"
  icon.font="$ICON_FONT"
  label='Preferences'
  label.font="$POPUP_LABEL_FONT"
)

apple_activity=(
  update_freq=0
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"

  icon="$ACTIVITY"
  icon.font="$ICON_FONT"
  label='Activity'
  label.font="$POPUP_LABEL_FONT"
)

apple_lock=(
  update_freq=0
  click_script="pmset displaysleepnow; $POPUP_OFF"

  icon="$LOCK"
  icon.font="$ICON_FONT"
  label='Lock Screen'
  label.font="$POPUP_LABEL_FONT"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item apple left                            \
           --set      apple "${apple[@]}"                   \
                                                            \
           --add item apple.prefs popup.apple               \
           --set      apple.prefs "${apple_prefs[@]}"       \
                                                            \
           --add item apple.activity popup.apple            \
           --set      apple.activity "${apple_activity[@]}" \
                                                            \
           --add item apple.lock popup.apple                \
           --set      apple.lock "${apple_lock[@]}"
