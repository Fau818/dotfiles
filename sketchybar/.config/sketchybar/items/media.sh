# -----------------------------------
# -------- Fields
# -----------------------------------
LABEL_FONT="$FONT:Medium:13.0"


# -----------------------------------
# -------- Preferences
# -----------------------------------
media=(
  updates=on
  update_freq=0
  script="$SCRIPT_DIR/media.sh"
  scroll_texts=on

  icon.background.drawing=on
  icon.background.image='media.artwork'
  icon.background.image.corner_radius=5
  icon.background.image.scale=0.85

  label.font="$LABEL_FONT"
  label.padding_left=5
  label.max_chars=10
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  media q             \
           --set       media "${media[@]}" \
           --subscribe media media_change
