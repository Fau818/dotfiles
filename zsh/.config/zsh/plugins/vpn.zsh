# =============================================
# ======== VPN (Linux Only)
# =============================================
[[ "$(uname)" == 'Linux' ]] || return

# ==================== VPN Settings ====================
proxy_port=7890
function __vpn_start() {
  # export https_proxy=http://127.0.0.1:$proxy_port http_proxy=http://127.0.0.1:$proxy_port all_proxy=socks5://127.0.0.1:$proxy_port
  export https_proxy=socks5h://127.0.0.1:$proxy_port http_proxy=socks5h://127.0.0.1:$proxy_port all_proxy=socks5h://127.0.0.1:$proxy_port
  echo_info 'VPN is enabled.'
}
function __vpn_stop() {
  unset https_proxy http_proxy all_proxy
  echo_info 'VPN is disabled.'
}

function vpn() {
  # With parameters
  if [[ "$1" == 'start' ]]; then __vpn_start
  elif [[ "$1" == 'stop' ]]; then __vpn_stop
  elif [[ -n "$1" ]]; then echo_error "Invalid parameter: $1. Usage: vpn [start|stop]" && return 1
  else [[ ! -v https_proxy ]] && __vpn_start || __vpn_stop
  fi
}


# ==================== VPN Control Functions ====================
# ---------- Quick Start Clash on Linux
function __get_clash_tool_name() {
  if command -v mihomo &> /dev/null; then echo 'mihomo'
  elif command -v clash &> /dev/null; then echo 'clash'
  else echo_error 'Not found: `clash/mihomo` command'; return 1
  fi
}

function startClash() {
  local tool_name; tool_name="$(__get_clash_tool_name)" || return 1
  # Start clash (NOTE: if you copied this code, you should use `sudo -E` instead of `sudo` else the config file will be missing.)
  # NOTE: The `sudo echo -n` is necessary since nohup will be suspended if no sudo permission.
  if pgrep -x "$tool_name" &> /dev/null; then echo_warn "$tool_name is already running!"
  else sudo echo -n && sudo nohup "$(which "$tool_name")" &> /dev/null &
  fi
}

function stopClash() {
  local tool_name; tool_name="$(__get_clash_tool_name)" || return 1
  # Find the running clash process and kill it with sudo permission.
  local tool_pid=$(pgrep -x "$tool_name")
  ([[ -n "$tool_pid" ]] && sudo kill "$tool_pid" && echo_ok "$tool_name has stopped!" && vpn stop) || echo_warn 'No running process found!'
}

function restartClash() {
  stopClash &> /dev/null && echo_ok 'Stopped Clash' || echo_error 'Failed to stop Clash'
  sleep 1
  startClash &> /dev/null && echo_ok 'Started Clash' || echo_error 'Failed to start Clash'
}


# -----------------------------------
# -------- Autostart
# -----------------------------------
function ___ssh_tunnel_listening() { ss -tlnp 2>/dev/null | grep -q ":$proxy_port "; }

function ___clash_is_running() {
  local tool_name; tool_name="$(__get_clash_tool_name &>/dev/null)" || return 1
  pgrep -x "$tool_name" &> /dev/null
}

function ___tun_is_active() { ip link show type tun 2>/dev/null | grep -q 'state UP'; }

function _auto_start_vpn() {
  # CASE1: SSH tunnel is listening.
  if ___ssh_tunnel_listening; then
    echo_info "SSH tunnel is listening on port $proxy_port, auto start VPN."
    __vpn_start
    return 0

  # CASE2: Clash is running.
  elif ___clash_is_running; then
    if ___tun_is_active; then echo_info "Clash TUN mode is active, no proxy needed."
    else echo_info "Clash is running, auto start VPN." && __vpn_start
    fi
    return 0
  fi
}

_auto_start_vpn
