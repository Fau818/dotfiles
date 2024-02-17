#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
CALENDAR=􀉉
CLOCK=􀐫


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'system_woke') sketchybar --set "$NAME" icon="$CALENDAR $(date '+%a %b %-d')" label="$(date '+%H:%M')"
    ;;
  *) echo "Invalid sender: $SENDER" in $0
    ;;
esac
