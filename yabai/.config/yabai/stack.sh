#!/usr/bin/env zsh

direction=$1
[[ -z "$direction" ]] && exit 1  # no direction given

# Get the stack-index of target window
target_stack_index=$(yabai -m query --windows --window $direction | jq -r '."stack-index"')

# Empty stack_index => no window
[[ -z "$target_stack_index" ]] && exit 1


if [ "$target_stack_index" -eq 0 ]; then
  # Target window is not in stack
  yabai -m window --stack $direction && yabai -m window --focus
else
  # Target window is in stack
  cur_win_id=$(yabai -m query --windows --window | jq -r '.id')
  yabai -m window --focus $direction && yabai -m window --stack $cur_win_id && yabai -m window --focus $cur_win_id
fi
