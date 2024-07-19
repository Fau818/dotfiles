# =============================================
# ======== Utils
# =============================================
# -----------------------------------
# -------- MISC
# -----------------------------------
# Kitty
[[ "$TERM" == 'xterm-kitty' ]] && alias kssh='kitty +kitten ssh'
# Rsync
command -v rsync &> /dev/null && alias frsync='rsync -razvhP'
# Mysql
command -v mysql &> /dev/null && alias mysqlStart='mysql.server start' mysqlStop='mysql.server stop'


# -----------------------------------
# -------- Docker
# -----------------------------------
# Allow option-stacking for docker completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


# -----------------------------------
# -------- Zoxide
# -----------------------------------
if command -v zoxide &> /dev/null; then
  # ==================== Init Zoxide ====================
  eval "$(zoxide init zsh --cmd j)"

  # ==================== Enhance Zoxide ====================
  _ZOXIDE_ECHO=true  # Set to `false` to disable echo
  _ZOXIDE_SHOULD=""; _ZOXIDE_INDEX=1; _ZOXIDE_LAST_QUERY=""; _ZOXIDE_DIRS=()
  function j() {
    # Query
    local query="$*"
    if [[ -n "$query" ]]; then
      if [[ ${_ZOXIDE_LAST_QUERY} != "$query" ]]; then
        _ZOXIDE_INDEX=1; _ZOXIDE_LAST_QUERY="$query"
        # NOTE: `$query` cannot be passed directly since it will be treated as a single argument. (Use `"$@"`)
        IFS=$'\n' && _ZOXIDE_DIRS=($(zoxide query --list "$@")) && unset IFS
      fi
    fi

    # Jump
    if [[ ${#_ZOXIDE_DIRS[@]} -eq 0 ]]; then echo_red 'zoxide: no directory found.'
    else
      [[ "$(pwd)" != "$_ZOXIDE_SHOULD" ]] && _ZOXIDE_INDEX=1;  # Reset index if the current directory has changed
      [[ "$_ZOXIDE_ECHO" == true ]] && echo "$_ZOXIDE_INDEX/${#_ZOXIDE_DIRS[@]}" "${_ZOXIDE_DIRS[$_ZOXIDE_INDEX]}"
      cd "${_ZOXIDE_DIRS[$_ZOXIDE_INDEX]}" || echo_red "zoxide: failed to ${_ZOXIDE_DIRS[$_ZOXIDE_INDEX]}."
      _ZOXIDE_INDEX=$((_ZOXIDE_INDEX % ${#_ZOXIDE_DIRS[@]} + 1))
      _ZOXIDE_SHOULD="$(pwd)"
    fi
  }
fi


# -----------------------------------
# -------- Yazi
# -----------------------------------
# SEE: https://yazi-rs.github.io/docs/quick-start#shell-wrapper
if (command -v yazi && ! command -v __yazi) &> /dev/null; then
  function __yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
  alias yazi=__yazi f=__yazi
fi


# -----------------------------------
# -------- Stow
# -----------------------------------
if (command -v stow && ! command -v __stow) &> /dev/null; then
  # Refactor stow
  function __stow() {
    # Parse args
    local opts=() pkgs=()
    for arg in "$@"; do
      if [[ "$arg" == -* ]]; then
        # EXIT: Invalid format
        [[ ! -z "$pkgs" ]] && echo_red "ERROR: Format should be [option ...] [-D|-S|-R] package ..." && return 0
        opts+=("$arg")
      else pkgs+=("$arg")
      fi
    done
    # EXIT: Empty packages
    [[ -z "$pkgs" ]] && (stow --help || return 0)

    # Execute
    [[ ! -v DOTFILE_PATH ]] && (DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles"))
    for name in "${pkgs[@]}"; do
      local dotfile_dir=$([[ -d "$DOTFILE_PATH/private/$name" ]] && echo "$DOTFILE_PATH/private" || echo "$DOTFILE_PATH")
      stow --dir="$dotfile_dir" --target="$HOME" --ignore='.DS_Store' "${opts[@]}" "$name"
    done
  }
  alias stow=__stow


  # Stow for installed binaries automatically
  function auto_stow() {
    typeset -A configs=(
      [clangd]='clangd'
      [fd]='fd'
      [git]='git'
      [github-copilot]='nvim'
      [kaggle]='kaggle'
      [kitty]='kitty'
      [lazygit]='lazygit'
      [sketchybar]='sketchybar'
      [ssh]='ssh'
      [wakatime]='wakatime-cli'
      [yazi]='yazi'
      [zsh]='zsh'
    )

    local config
    for config in "${(@k)configs}"; do
      local binary=${configs[$config]}
      if command -v "$binary" &> /dev/null; then
        __stow "$config"
        echo_blue "Stowed configuration for '$config'."
      fi
    done
  }
fi
