#!/usr/bin/env bash

# -----------------------------------
# -------- Icons
# -----------------------------------
QQ=󰘅
WECHAT=󰘑
EMAIL=󰇮


# -----------------------------------
# -------- Colors
# -----------------------------------
QQ_COLOR=0xFF87AEEB
WECHAT_COLOR=0xFF5ECD72
EMAIL_COLOR=0xFF5595DB


# -----------------------------------
# -------- Fields
# -----------------------------------
ICON_FONT="$NERD_FONT:Regular:16.0"
WECHAT_ICON_FONT="$NERD_FONT:Regular:19.0"
LABEL_FONT="$FONT:Medium:13.0"
UPDATE_FREQ=30


# -----------------------------------
# -------- Scripts
# -----------------------------------
OPEN_QQ='open -a QQ'
OPEN_WECHAT='open -a WeChat'
OPEN_EMAIL='open -a Mail'


# -----------------------------------
# -------- Preferences
# -----------------------------------
qq=(
  update_freq="$UPDATE_FREQ"
  script="$SCRIPT_DIR/app_status.sh"
  click_script="$OPEN_QQ"

  icon="$QQ"
  icon.font="$ICON_FONT"
  icon.color="$QQ_COLOR"
  icon.padding_right=0  # NOTE: Special for each item

  label='?'
  label.font="$LABEL_FONT"
  label.color="$WHITE"
  label.padding_left=0
  label.padding_right="$BACKGROUND_MARGIN"  # NOTE: Bracket End

  background.padding_left=3
  background.padding_right=0
)

wechat=(
  update_freq="$UPDATE_FREQ"
  script="$SCRIPT_DIR/app_status.sh"
  click_script="$OPEN_WECHAT"

  icon="$WECHAT"
  icon.font="$WECHAT_ICON_FONT"
  icon.color="$WECHAT_COLOR"
  icon.padding_right=2  # NOTE: Special for each item

  label='?'
  label.font="$LABEL_FONT"
  label.color="$WHITE"
  label.padding_left=0

  background.padding_left=3
  background.padding_right=0
)

email=(
  update_freq="$UPDATE_FREQ"
  script="$SCRIPT_DIR/app_status.sh"
  click_script="$OPEN_EMAIL"

  icon="$EMAIL"
  icon.font="$ICON_FONT"
  icon.color="$EMAIL_COLOR"
  icon.padding_left="$BACKGROUND_MARGIN"  # NOTE: Bracket Begin
  icon.padding_right=2  # NOTE: Special for each item

  label='?'
  label.font="$LABEL_FONT"
  label.color="$WHITE"
  label.padding_left=0

  background.padding_left=0
  background.padding_right=0
)


app_bracket=(
  background.color="$BACKGROUND_COLOR"
)


# -----------------------------------
# -------- Setup
# -----------------------------------
sketchybar --add item  qq right                      \
           --set       qq "${qq[@]}"                 \
                                                     \
           --add item  wechat right                  \
           --set       wechat "${wechat[@]}"         \
                                                     \
           --add item  email right                   \
           --set       email "${email[@]}"           \
                                                     \
           --add bracket app_bracket qq wechat email \
           --set         app_bracket "${app_bracket[@]}"
