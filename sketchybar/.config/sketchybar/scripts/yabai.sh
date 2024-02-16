#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
YABAI_BSP=􀏜
YABAI_STACK=􀏭
YABAI_FLOAT=􀢌
ERROR_ICON=􀏎
# YABAI_PARENT_ZOOM=􀥃
# YABAI_GRID=􀧍


# -----------------------------------
# -------- Colors
# -----------------------------------
RED=0xFFED8796
BLUE=0xFF8AADF4 FLOAT_LAYOUT_COLOR="$BLUE"
YELLOW=0xFFEED49F BSP_LAYOUT_COLOR="$YELLOW"
MAGENTA=0xFFC6A0F6 STACK_LAYOUT_COLOR="$MAGENTA"


# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_yabai_status() {
  # Init variables
  icon="$ERROR_ICON" label='ERROR' color="$RED";
  # Get the window state
  window_info="$(yabai -m query --windows --window)"

  # CASE 1: Floating window
  if [[ "$(echo "$window_info" | jq -r '."is-floating"')" == 'true' ]]; then
    icon="$YABAI_FLOAT" label='Float' color="$FLOAT_LAYOUT_COLOR";
  else
    space_type="$(yabai -m query --spaces --space | jq -r '.type')"
    # CASE 2: Floating layout
    if [[ "$space_type" == 'float' ]]; then
      icon="$YABAI_FLOAT" label='FLOAT' color="$FLOAT_LAYOUT_COLOR";
    else
      stack_index="$(echo "$window_info" | jq '.["stack-index"]')"
      # CASE 3: No stack index => show layout type
      if [[ "$stack_index" == 0 ]]; then
        if [[ "$space_type" == 'bsp' ]]; then icon="$YABAI_BSP" label='BSP' color="$BSP_LAYOUT_COLOR";
        elif [[ "$space_type" == 'stack' ]]; then icon="$YABAI_STACK" label='STACK' color="$STACK_LAYOUT_COLOR";
        else echo "Invalid space type: `$space_type`" in $0
        fi
      else  # CASE 4: Stack multiple windows
        last_stack_index="$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')"
        icon="$YABAI_STACK"
        label="$(printf "[%s/%s]" "$stack_index" "$last_stack_index")"
        color="$STACK_LAYOUT_COLOR"
      fi
    fi
  fi

  sketchybar --set "$NAME" icon="$icon" label="$label" icon.color="$color" label.color="$color"
}


# function update_yabai_status() {
#   # Init variables
#   icon="$ERROR_ICON" label='ERROR' color="$RED";
#   # Get the window state
#   window_info="$(yabai -m query --windows --window)"

#   # CASE 1: Floating window
#   if [[ "$(echo "$window_info" | jq -r '."is-floating"')" == 'true' ]]; then
#     icon="$YABAI_FLOAT" label='Float' color="$FLOAT_LAYOUT_COLOR";
#   else
#     space_type="$(yabai -m query --spaces --space | jq -r '.type')"
#     # CASE 2: Floating layout
#     if [[ "$space_type" == 'float' ]]; then
#       icon="$YABAI_FLOAT" label='FLOAT' color="$FLOAT_LAYOUT_COLOR";
#     # CASE 3: Binary Space Partitioning (BSP) layout
#     elif [[ "$space_type" == 'bsp' ]]; then
#       stack_index="$(echo "$window_info" | jq '.["stack-index"]')"
#       # CASE 3.1: Normal BSP layout
#       if [[ "$stack_index" == 0 ]]; then
#         icon="$YABAI_BSP" label='BSP' color="$BSP_LAYOUT_COLOR";
#       else  # CASE 3.2: Stack layout in BSP
#         last_stack_index="$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')"
#         icon="$YABAI_STACK"
#         label="$(printf "[%s/%s]" "$stack_index" "$last_stack_index")"
#         color="$STACK_LAYOUT_COLOR"
#       fi
#     # CASE 4: Stack layout
#     elif [[ "$space_type" == 'stack' ]]; then
#       stack_index="$(echo "$window_info" | jq '.["stack-index"]')"
#       # CASE 4.1: Stack single window (only in stack layout)
#       if [[ "$stack_index" == 0 ]]; then
#         icon="$YABAI_STACK" label='STACK' color="$STACK_LAYOUT_COLOR";
#       else  # CASE 4.2: Stack multiple windows
#         last_stack_index="$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')"
#         icon="$YABAI_STACK"
#         label="$(printf "[%s/%s]" "$stack_index" "$last_stack_index")"
#         color="$STACK_LAYOUT_COLOR"
#       fi
#     fi
#   fi

#   sketchybar --set "$NAME" icon="$icon" label="$label" icon.color="$color" label.color="$color"
# }


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'skhd_space_type_changed'|'skhd_window_type_changed'|'yabai_window_focused'|'yabai_loaded') update_yabai_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
