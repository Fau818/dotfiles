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
function update_memory_status() {
  # Get basic memory information
  total_memory="$(sysctl -n hw.memsize)"
  vm_stat_output="$(vm_stat)"
  free_memory_pages=$(echo "$vm_stat_output" | grep free | awk '{ print $3 }' | sed 's/\.//')
  page_size=$(vm_stat | grep "page size of" | awk '{ print $8 }')

  # Calculate usage
  free_memory_bytes=$(($free_memory_pages * $page_size))
  total_memory_bytes=$(($total_memory))
  used_memory_bytes=$(($total_memory_bytes - $free_memory_bytes))

  # Get result
  memory_usage=$(awk "BEGIN {print $used_memory_bytes / $total_memory_bytes}")
  memory_usage_percentage=$(awk "BEGIN {printf \"%02.0f%%\", $memory_usage * 100}")

  color="$DEFAULT"
  if (( $(echo "$memory_usage <= 0.50" | bc -l) )); then color="$LOW"
  elif (( $(echo "$memory_usage <= 0.75" | bc -l) )); then color="$MEDIUM"
  else color="$HIGH"
  fi

  sketchybar --set memory_percent label="$memory_usage_percentage" icon.color="$color" label.color="$color" \
             --set memory_icon icon.color="$color"
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'routine') update_memory_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
