#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_media_status() {
  app="$(echo "$INFO" | jq -r '.app')"
  if [[ "$app" == 'Arc' ]]; then
    sketchybar --set "$NAME" drawing=off
    return 0
  fi

  state="$(echo "$INFO" | jq -r '.state')"

  # { "state": "playing", "title": "name", "album": "xxxx", "artist": "singer", "app": "Spotify" }
  if [[ "$state" == 'playing' ]]; then
    # app=$(echo "$INFO" | jq -r '.app')
    media="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
    sketchybar --set "$NAME" drawing=on label="$media"
  else
    sketchybar --set "$NAME" drawing=off
  fi

}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced')
    ;;
  'media_change') update_media_status
    ;;
  *) echo "Invalid sender: $SENDER" in $0
    ;;
esac
