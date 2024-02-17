#!/usr/bin/env zsh

[[ "$(yabai -m query --spaces --space | jq '.windows | length')" == 0 ]] && yabai -m space --destroy
