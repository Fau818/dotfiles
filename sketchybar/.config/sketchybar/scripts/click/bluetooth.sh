#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
if [ "$BUTTON" == 'left' ]; then
  [[ "$(blueutil --power)" == 1 ]] && blueutil --power 0 || blueutil --power 1
elif [ "$BUTTON" == 'right' ]; then
  open '/System/Library/PreferencePanes/Bluetooth.prefPane'
fi
