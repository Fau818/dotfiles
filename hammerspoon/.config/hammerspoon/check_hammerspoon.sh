#!/usr/bin/env zsh

# ==================== Checking for memory leaks in Hammerspoon ====================
hammerspoon_pid=$(pgrep Hammerspoon)
[[ -z "$hammerspoon_pid" ]] && exit 0

mem_usage=$(ps -o rss= -p "$hammerspoon_pid" | awk '{print int($1/1024)}')
echo $mem_usage
if [[ $mem_usage -gt 200 ]]; then
  # Send to Notification Center
  osascript -e 'display notification "Hammerspoon is using too much memory." with title "Hammerspoon"'
  # Restart
  pkill Hammerspoon && sleep 1 && open -a Hammerspoon
fi
