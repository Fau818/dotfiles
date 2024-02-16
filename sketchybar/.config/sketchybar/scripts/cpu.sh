#!/usr/bin/env bash

# -----------------------------------
# -------- Colors
# -----------------------------------
LOW=0xFFA6DA95
MEDIUM=0xFFEED49F
HIGH=0xFFED8796
DEFAULT=0xFFCAD3F5


# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_cpu_status() {
  cpu_cores="$(sysctl -n hw.ncpu)"
  cpu_usage=$(ps -A -o %cpu | awk -v cores=$cpu_cores '{s+=$1} END {printf "%.4f", s/cores/100}')
  cpu_usage_percentage=$(awk "BEGIN {printf \"%02.0f%%\", $cpu_usage * 100}")

  color="$DEFAULT"
  if (( $(echo "$cpu_usage <= 0.50" | bc -l) )); then color="$LOW"
  elif (( $(echo "$cpu_usage <= 0.75" | bc -l) )); then color="$MEDIUM"
  else color="$HIGH"
  fi


  sketchybar --set cpu_percent label="$cpu_usage_percentage" icon.color="$color" label.color="$color" \
             --set cpu_icon icon.color="$color"
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'routine') update_cpu_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
