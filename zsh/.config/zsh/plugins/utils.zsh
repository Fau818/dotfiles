# =============================================
# ======== Utils
# =============================================
# -----------------------------------
# -------- MISC
# -----------------------------------
# Kitty
[ "$TERM" = 'xterm-kitty' ] && alias kssh='kitty +kitten ssh'
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
  export _ZO_DATA_DIR="$XDG_DATA_HOME"
  # alias z=__zoxide_z zi=__zoxide_zi
  eval "$(zoxide init zsh --cmd j)"
fi


# -----------------------------------
# -------- Yazi
# -----------------------------------
if (command -v yazi && ! command -v __yazi) &> /dev/null; then
  function __yazi() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
  alias yazi=__yazi
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
      [clangd]="clangd"
      [git]="git"
      [github-copilot]="nvim"
      [kaggle]="kaggle"
      [lazygit]="lazygit"
      [sketchybar]="sketchybar"
      [ssh]="ssh"
      [wakatime]="wakatime-cli"
      [yazi]="yazi"
      [zsh]="zsh"
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
