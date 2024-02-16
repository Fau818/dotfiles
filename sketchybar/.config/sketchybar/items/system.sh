# -----------------------------------
# -------- Icons
# -----------------------------------
ICON_CPU=􀫥
ICON_MEMORY=􀫦
# ICON_DISK= 􀜋 􀑀


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$FONT:Bold:12.0"
LABEL_FONT="$NERD_FONT:Bold:11.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
# Cpu
cpu_icon=(
  update_freq=0
  width=0
  y_offset=5

  icon="$ICON_CPU"
  icon.font="$ICON_FONT"
  icon.color="$GRAY"
  icon.padding_left=0
  icon.padding_right=7

  label.drawing=off

  background.padding_left=0
  background.padding_right=0
)

cpu_percent=(
  update_freq=5
  script="$SCRIPT_DIR/cpu.sh"
  y_offset=-6
  padding_left=5

  icon.drawing=off

  label='??%'
  label.font="$LABEL_FONT"
  label.color="$GRAY"
  label.width=25
  label.align=center
)

# Memory
memory_icon=(
  update_freq=0
  width=0
  y_offset=5

  icon="$ICON_MEMORY"
  icon.font="$ICON_FONT"
  icon.color="$GRAY"
  icon.padding_left=0
  icon.padding_right=12

  label.drawing=off
)

memory_percent=(
  update_freq=5
  script="$SCRIPT_DIR/memory.sh"
  y_offset=-6
  padding_left=5
  padding_right=5

  icon.drawing=off

  label='??%'
  label.font="$LABEL_FONT"
  label.color="$GRAY"
  label.width=25
  label.align=center
)


system_bracket=(
  background.color="$BACKGROUND_COLOR"
)

gap=(
  icon.drawing=off
  label.drawing=off
  padding_left=5
  # padding_right=5
)

# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item memory_icon    right                  \
           --set      memory_icon    "${memory_icon[@]}"    \
           --add item memory_percent right                  \
           --set      memory_percent "${memory_percent[@]}" \
           \
           --add item cpu_icon    right               \
           --set      cpu_icon    "${cpu_icon[@]}"    \
           --add item cpu_percent right               \
           --set      cpu_percent "${cpu_percent[@]}" \
           \
           --add bracket system_bracket cpu_icon cpu_percent memory_icon memory_percent \
           --set         system_bracket "${system_bracket[@]}"

# BUG: two brackets gap
sketchybar --add item gap right \
           --set      gap "${gap[@]}"
