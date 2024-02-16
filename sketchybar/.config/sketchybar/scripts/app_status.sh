#!/usr/bin/env bash

# -----------------------------------
# -------- Scripts
# -----------------------------------
function update_app_status() {
  # CASE: Special case for email.
  if [[ "$NAME" == 'email' ]]; then
    LABEL=$(osascript -e 'tell application "Mail" to return the unread count of inbox')
    sketchybar --set "$NAME" label="$LABEL"
    return 0
  fi

  if lsappinfo -all list | grep "$NAME" >> /dev/null; then
    LABEL=$(lsappinfo -all list | grep "$NAME" | egrep -o "\"StatusLabel\"=\{ \"label\"=\"?(.*?)\"? \}" | sed 's/\"StatusLabel\"={ \"label\"=\(.*\) }/\1/g')
    if [[ $LABEL =~ ^\".*\"$ ]]; then
      LABEL=$(echo $LABEL | sed 's/^"//' | sed 's/"$//')
      [ -z "$LABEL" ] && LABEL=0
    else LABEL=0
    fi
  else LABEL='?'
  fi

  sketchybar --set "$NAME" label="$LABEL"
}


# -----------------------------------
# -------- Trigger
# -----------------------------------
case "$SENDER" in
  'forced'|'routine') update_app_status
    ;;
  *) echo "Invalid sender: `$SENDER`" in $0
    ;;
esac
