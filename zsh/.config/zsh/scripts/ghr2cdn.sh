#!/bin/bash

# Function to convert GitHub raw URL to jsDelivr CDN URL
convert_to_jsdelivr() {
  raw_url="$1"  # Get the raw URL from the first script argument

  # Validate the input URL
  if [[ ! $raw_url =~ ^https://raw.githubusercontent.com/ ]]; then
    echo "Error: URL must start with https://raw.githubusercontent.com/"
    exit 1
  fi

  # Remove the protocol and domain
  url_no_protocol=${raw_url/https:\/\/raw.githubusercontent.com\//}

  # Split the URL into parts
  IFS='/' read -r -a parts <<< "$url_no_protocol"

  # Ensure the URL has enough parts
  if [[ ${#parts[@]} -lt 4 ]]; then
    echo "Error: URL must include user, repository, branch, and file path."
    exit 1
  fi

  # Extract user, repository, and branch
  user="${parts[0]}"
  repo="${parts[1]}"
  branch="${parts[2]}"

  # Reconstruct the file path
  file_path="${parts[@]:3}"
  file_path=$(IFS='/'; echo "${parts[*]:3}")

  # Construct the jsDelivr URL
  jsdelivr_url="https://cdn.jsdelivr.net/gh/${user}/${repo}@${branch}/${file_path}"

  echo $jsdelivr_url
}

# Main script starts here
if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <github_raw_url>"
  exit 1
fi

# Convert the provided GitHub raw URL to jsDelivr CDN URL
convert_to_jsdelivr "$1"
