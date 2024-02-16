#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_front_app_status() {
  sketchybar --set "$NAME" label="$INFO" icon.background.image="app.$INFO" \
             --animate tanh 10 \
             --set "$NAME" icon.background.image.scale=1.0 icon.background.image.scale=0.8
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced')
    ;;
  'front_app_switched') update_front_app_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
