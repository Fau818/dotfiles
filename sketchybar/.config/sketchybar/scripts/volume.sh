#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
# Volume Icons
VOLUME_100=􀊩
VOLUME_66=􀊧
VOLUME_33=􀊥
VOLUME_10=􀊥
# VOLUME_10=􀊡
VOLUME_0=􀊣
VOLUME_ERROR=􀾐


# -----------------------------------
# -------- Fields
# -----------------------------------
WIDTH=75
BACKGROUND_MARGIN=8
PADDING=3


# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_volume_status() {
  VOLUME_PERCENT="$INFO"
  case "$VOLUME_PERCENT" in
    [7-9][0-9]|100) icon="$VOLUME_100"
    ;;
    [3-6][0-9])     icon="$VOLUME_66"
    ;;
    [1-2][0-9])     icon="$VOLUME_33"
    ;;
    [1-9])          icon="$VOLUME_10"
    ;;
    0)              icon="$VOLUME_0"
    ;;
    *)              icon="$VOLUME_ERROR"
  esac

  sketchybar --set volume icon="$icon" label="$VOLUME_PERCENT%" \
             --set volume_slider slider.percentage="$VOLUME_PERCENT"

  slider_width="$(sketchybar --query volume_slider | jq -r ".slider.width")"
  if [[ "$slider_width" == 0 ]]; then
    sketchybar --animate tanh 30 \
               --set volume_slider slider.width="$WIDTH" background.padding_right="$BACKGROUND_MARGIN" \
               --set volume label.padding_right="$PADDING"
  fi
  sleep 2

  # Check wether the volume was changed another time while sleeping
  final_percentage="$(sketchybar --query volume_slider | jq -r ".slider.percentage")"
  if [[ "$final_percentage" -eq "$VOLUME_PERCENT" ]]; then
    sketchybar --animate tanh 30 \
               --set volume_slider slider.width=0 background.padding_right=0 \
               --set volume label.padding_right="$BACKGROUND_MARGIN"
  fi
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced')
    ;;
  'volume_change') update_volume_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
