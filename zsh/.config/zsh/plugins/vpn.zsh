# =============================================
# ======== VPN
# =============================================
# -----------------------------------
# -------- VPN Setter
# -----------------------------------
function __vpn_start() {
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
  echo_info 'VPN is enabled.'
}
function __vpn_stop() {
  unset https_proxy http_proxy all_proxy
  echo_info 'VPN is disabled.'
}
function vpn() {
  # With parameters
  if [[ "$1" == 'start' ]]; then __vpn_start; return 0
  elif [[ "$1" == 'stop' ]]; then __vpn_stop; return 0
  elif [[ -n "$1" ]]; then echo_error 'Invalid parameter, use auto toggle.'
  fi

  # Auto toggle
  [[ ! -v https_proxy ]] && __vpn_start || __vpn_stop
}

# Quick Start VPN on Linux
if [[ "$(uname)" == 'Linux' ]]; then
  function startClash() {
    local tool_name="$(command -v mihomo &> /dev/null && echo 'mihomo' || echo 'clash')"
    # Check `clash` command
    (! command -v "$tool_name" &> /dev/null) && echo_error 'Not found: `clash/mihomo` command' && return 1
    # Start clash (NOTE: if you copied this code, you should use `sudo -E` instead of `sudo` else the config file will be missing.)
    # NOTE: The `sudo echo -n` is necessray since nohup will be suspended if no sudo permission.
    (pgrep -x "$tool_name" &> /dev/null && echo_warn "$tool_name is already running!") || (sudo echo -n && sudo nohup "$(which $tool_name)" > /dev/null &)
    # Start VPN
    # vpn start
  }

  function stopClash() {
    local tool_name="$(command -v mihomo &> /dev/null && echo 'mihomo' || echo 'clash')"
    # Check `clash` command
    (! command -v "$tool_name" &> /dev/null) && echo_error 'Not found: `clash/mihomo` command' && return 1
    # Find the running clash process and kill it with sudo permission.
    local tool_pid=$(pgrep -x "$tool_name")
    ([[ -n "$tool_pid" ]] && sudo kill "$tool_pid" && echo_ok "$tool_name has stopped!" && vpn stop) || echo_warn 'No running process Found!'
  }

  function restartClash() {
    stopClash &> /dev/null && echo_ok 'Stopped Clash' || echo_error 'Failed to stop Clash'
    sleep 1
    startClash &> /dev/null && echo_ok 'Started Clash' || echo_error 'Failed to start Clash'
  }
fi


# -----------------------------------
# -------- Autostart
# -----------------------------------
# function _auto_start_vpn() {
#   local tool_name="$(command -v mihomo &> /dev/null && echo 'mihomo' || echo 'clash')"
#   if [[ "$(uname)" == 'Darwin' ]]; then ;  # pgrep -i "$tool_name" &> /dev/null && vpn start
#   elif [[ "$(uname)" == 'Linux' ]]; then pgrep -x "$tool_name" &> /dev/null && vpn start
#   else echo_red 'Not supported: Unknown OS, auto start VPN failed.'
#   fi
# }
