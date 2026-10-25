// Cloudflare Worker behind https://starter.phoenix818.cloud
// Returns a short loader that fetches `starter.sh` from GitHub, so changing the script needs no redeploy.
// Deploy: Workers & Pages > Create > Worker, paste this file, then Settings > Domains & Routes >
// Add > Custom domain `starter.phoenix818.cloud` (Cloudflare creates the DNS record and certificate).

// NOTE: `String.raw` keeps backslashes as written; the shell code below still must not contain backticks or `${`.
const LOADER = String.raw`#!/usr/bin/env bash
# Phoenix's dotfiles starter. Run it with:  curl https://starter.phoenix818.cloud | bash
# Options go after "bash -s --", e.g.:  curl https://starter.phoenix818.cloud | bash -s -- --help
set -e
url=https://raw.githubusercontent.com/Fau818/dotfiles/main/starter.sh
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$url" -o "$tmp"
# Give the real script the terminal as input, since this one is reading from curl's pipe.
if [ -t 1 ] && { : < /dev/tty; } 2> /dev/null; then bash "$tmp" "$@" < /dev/tty; else bash "$tmp" "$@"; fi
`;

export default {
  fetch() {
    return new Response(LOADER, { headers: { "content-type": "text/plain; charset=utf-8" } });
  },
};
