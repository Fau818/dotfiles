#!/bin/bash

jsdelivr_url=$1
if [[ -z "$jsdelivr_url" ]]; then
  echo "Usage: $0 <jsdelivr-url>"
  exit 1
fi
github_raw_url=$(echo $jsdelivr_url | sed -e 's#cdn.jsdelivr.net/gh#raw.githubusercontent.com#' -e 's#@#/#')
echo $github_raw_url
