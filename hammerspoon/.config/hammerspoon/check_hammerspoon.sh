#!/usr/bin/env bash

# Checking for memory leaks in Hammerspoon.
mem_usage=$(ps -o rss= -p $(pgrep Hammerspoon))
if [ "$mem_usage" -gt $((200 * 1024)) ]; then
  osascript -e 'tell application "Hammerspoon" to quit'
  open -a Hammerspoon
fi
