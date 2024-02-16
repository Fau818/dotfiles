#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_media_status() {
  state="$(echo "$INFO" | jq -r '.state')"

  # { "state": "playing", "title": "name", "album": "xxxx", "artist": "singer", "app": "Spotify" }
  if [[ "$state" == 'playing' ]]; then
    # app=$(echo "$INFO" | jq -r '.app')
    media="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
    sketchybar --set "$NAME" label="$media" drawing=on
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
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
