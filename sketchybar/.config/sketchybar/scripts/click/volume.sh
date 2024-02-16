#!/usr/bin/env bash

# -----------------------------------
# -------- Fields
# -----------------------------------
WIDTH=75


# -----------------------------------
# -------- Scripts
# -----------------------------------
function _show_slider() { sketchybar --animate tanh 30 --set volume_slider slider.width="$WIDTH"; }

function _hide_slider() { sketchybar --animate tanh 30 --set volume_slider slider.width=0; }

function toggle_slider() {
  slider_width="$(sketchybar --query volume_slider | jq -r '.slider.width')"
  [[ "$slider_width" == 0 ]] && _show_slider || _hide_slider
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
toggle_slider
