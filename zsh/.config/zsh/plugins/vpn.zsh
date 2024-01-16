# =============================================
# ======== VPN
# =============================================
# -----------------------------------
# -------- VPN Setter
# -----------------------------------
function vpn() {
  if [ "$1" = 'start' ]; then
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    echo_yellow 'VPN is enabled.'
    return 0
  fi

  if [ ! -v https_proxy ]; then
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    echo_yellow 'VPN is enabled.'
  else
    unset https_proxy http_proxy all_proxy
    echo_yellow 'VPN is disabled.'
  fi
}

# Quick Start VPN on Linux
if [ "$(uname)" = 'Linux' ]; then
  function startClash() {
    # Check `clash` command
    (! command -v clash &> /dev/null) && echo_red 'Not found: `clash` command' && return 1
    # Start clash
    (pgrep -x clash &> /dev/null && echo_yellow 'Clash is already running!') || nohup clash > /dev/null &
    # Start VPN
    vpn start
  }
fi


# -----------------------------------
# -------- Autostart
# -----------------------------------
if [ "$(uname)" = 'Darwin' ]; then vpn start
elif [ "$(uname)" = 'Linux' ]; then pgrep -x clash &> /dev/null && vpn start
else echo_red 'Not supported: Unknown OS, auto start VPN failed.'
fi
