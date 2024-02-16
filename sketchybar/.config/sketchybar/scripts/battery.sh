#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
BATTERY_100=􀛨
BATTERY_75=􀺸
BATTERY_50=􀺶
BATTERY_25=􀛩
BATTERY_0=􀛪
BATTERY_CHARGING=􀢋


# -----------------------------------
# -------- Colors
# -----------------------------------
HEALTH=0xFFA6DA95
NORMAL=0xFFF5A97F
DEATH=0xFFED8796
WHITE=0xFFCAD3F5


# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_battery() {
  battery_info="$(pmset -g batt)"
  percentage="$(echo "$battery_info" | grep -Eo "\d+%" | cut -d% -f1)"
  charging="$(echo "$battery_info" | grep 'AC Power')"

  # EXIT: No battery info.
  [[ "$percentage" = '' ]] && echo 'Get battery info failed' && exit 1

  icon="$BATTERY_0"; color="$WHITE"
  case "$percentage" in
    9[0-9]|100) icon="$BATTERY_100" color="$HEALTH"
      ;;
    [6-8][0-9]) icon="$BATTERY_75"  color="$HEALTH"
      ;;
    [3-5][0-9]) icon="$BATTERY_50"  color="$NORMAL"
      ;;
    [1-2][0-9]) icon="$BATTERY_25"  color="$DEATH"
      ;;
    0[0-9])     icon="$BATTERY_0"   color="$DEATH"
      ;;
    *)          icon="$BATTERY_0"   color="$WHITE"
      echo "Invalid battery percentage: $percentage"
      ;;
  esac

  [[ "$charging" != '' ]] && icon="$BATTERY_CHARGING"

  sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="$percentage%" label.color="$color"
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'routine'|'power_source_change'|'system_woke') update_battery
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
