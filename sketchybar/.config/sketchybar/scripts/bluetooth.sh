#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
ON=
OFF=


# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_bluetooth_status() {
  [[ "$(blueutil -p)" == 0 ]] && label="$OFF" || label="$ON"
  sketchybar --set "$NAME" label="$label"
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'bluetooth_on'|'bluetooth_off') update_bluetooth_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
