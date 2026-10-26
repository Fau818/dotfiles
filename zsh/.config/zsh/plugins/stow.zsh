# ╔══════════════════════════════════════════════════════════╗
# ║                           Stow                           ║
# ╚══════════════════════════════════════════════════════════╝

(( $+commands[stow] && ! $+functions[__stow] )) || return  # NOTE: Only once, else the `stow` alias makes `__stow` recurse

# Refactor stow
function __stow() {
  # Parse args
  local opts=() pkgs=()
  for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
      # EXIT: Invalid format
      (( ${#pkgs[@]} > 0 )) && echo_error 'ERROR: Format should be [option ...] [-D|-S|-R] package ...' && return 0
      opts+=("$arg")
    else pkgs+=("$arg")
    fi
  done
  # EXIT: Empty packages
  (( ${#pkgs[@]} == 0 )) && { stow --help; return 0; }

  # Execute
  [[ ! -v DOTFILE_PATH ]] && { DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles"); }

  local ret=0
  for name in "${pkgs[@]}"; do
    # NOTE: Some packages require a directory to exist before stowing.
    [[ "$name" == 'ssh' ]] && [[ ! -d "$HOME/.ssh" ]] && mkdir -p "$HOME/.ssh"
    [[ "$name" == 'claude' ]] && [[ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/claude" ]] && mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/claude"

    local dotfile_dir=$([[ -d "$DOTFILE_PATH/private/$name" ]] && echo "$DOTFILE_PATH/private" || echo "$DOTFILE_PATH")
    # CASE: Skipped a package is absent from this checkout, e.g. `private` is not initialized.
    [[ -d "$dotfile_dir/$name" ]] || { echo_warn "Skipped $(echo_hl "$name"): no such package in $(echo_hl "$dotfile_dir")."; ret=1; continue }
    stow --dir="$dotfile_dir" --target="$HOME" --ignore='\.DS_Store' --ignore='\.claude' "${opts[@]}" "$name" || ret=1
  done
  return "$ret"
}
alias stow=__stow


# Stow for installed binaries automatically
function auto_stow() {
  typeset -A configs=(
    [bat]='bat'
    [clangd]='clangd'
    [ccstatusline]='claude'
    [claude]='claude'
    [conda]='conda'
    [fd]='fd'
    [git]='git'
    [github-copilot]='nvim'
    [hammerspoon]='hs'
    [kaggle]='conda'
    [karabiner]='karabiner_cli'
    [kitty]='kitty'
    [lazygit]='lazygit'
    [netrc]='python3'
    [pip]='python3'
    [sketchybar]='sketchybar'
    [ssh]='ssh'
    [uv]='uv'
    [vscode]='code'
    [wakatime]='wakatime-cli'
    [yazi]='yazi'
    [yabai]='yabai'
    [zsh]='zsh'
  )

  local config
  for config in "${(@k)configs}"; do
    local binary=${configs[$config]}
    # NOTE: Use `command -v`, as `$+commands` misses a tool installed since the shell started.
    if command -v "$binary" &> /dev/null; then __stow "$config" && echo_ok "Stowed configuration for $(echo_hl "$config")."; fi
  done
}
