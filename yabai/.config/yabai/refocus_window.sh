#!/usr/bin/env zsh

# NOTE: This script is used to keep focus on window.
# \     If the app is in white_list or in extra_list, it will focus to the last managed window when the window losed focus.

# If focused on a window => there is an app window in current space => do nothing
# EXIT: Not lose focus
yabai -m query --windows --window &> /dev/null && exit 0

# There is no app window in current space
app_name=$(osascript -e 'tell application "System Events" to get name of application processes whose frontmost is true and visible is true')

app_list="$1"
[[ "$app_name" =~ "$app_list" ]] && (yabai -m window --focus recent || yabai -m window --focus last)
