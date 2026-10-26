# ╔══════════════════════════════════════════════════════════╗
# ║                          Utils                           ║
# ╚══════════════════════════════════════════════════════════╝

# ══════════════════════════ Zoxide ══════════════════════════

if command -v zoxide &> /dev/null; then
  # ─── Init Zoxide ──────────────────────────────────────────
  cached_eval zoxide init zsh --cmd j


  # ─── Enhance Zoxide ───────────────────────────────────────
  _ZOXIDE_ECHO=1           # Set to 0 to disable echo
  _ZOXIDE_RETRACT_SECS=60  # How soon after a jump moving on to the next match marks it a miss
  _ZOXIDE_QUERY=() _ZOXIDE_DIRS=() _ZOXIDE_INDEX=0 _ZOXIDE_LANDED='' _ZOXIDE_LANDED_AT=0

  # Jump to the best zoxide match for `$@`; returns non-zero on failure.
  # - New query: searches afresh, skipping the current directory.
  # - Repeated: goes to the next match, undoing the last one's point.
  # - No match: picks with fzf.
  function j() {
    local -a query=("$@")
    local dir
    (( $# )) || query=("${_ZOXIDE_QUERY[@]}")

    # Query
    # NOTE: Keywords are compared quoted, so `j 'a b'` and `j a b` are different queries.
    if (( ${#_ZOXIDE_DIRS} )) && [[ "$PWD" == "$_ZOXIDE_LANDED" && "${(j: :)${(@q)query}}" == "${(j: :)${(@q)_ZOXIDE_QUERY}}" ]]; then
      (( SECONDS - _ZOXIDE_LANDED_AT <= _ZOXIDE_RETRACT_SECS )) && zoxide edit decrement "$PWD" > /dev/null
      _ZOXIDE_INDEX=$(( _ZOXIDE_INDEX % ${#_ZOXIDE_DIRS} + 1 ))
    else
      _ZOXIDE_QUERY=("${query[@]}") _ZOXIDE_DIRS=() _ZOXIDE_INDEX=1
      (( ${#query} )) && _ZOXIDE_DIRS=(${(f)"$(zoxide query --list --exclude "$PWD" -- "${query[@]}")"})
    fi

    # Jump
    if (( ! ${#_ZOXIDE_DIRS} )); then
      # Fallback: fzf with the keywords as its initial query
      dir="$(FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --query=${(qq)${(j: :)query}}" zoxide query --interactive)" && cd -- "$dir"
      return
    fi
    dir="${_ZOXIDE_DIRS[_ZOXIDE_INDEX]}"
    (( _ZOXIDE_ECHO )) && print -r -- "$_ZOXIDE_INDEX/${#_ZOXIDE_DIRS} $dir"
    cd -- "$dir" || { echo_error "zoxide: failed to enter $(echo_hl "$dir")."; return 1 }
    _ZOXIDE_LANDED="$PWD" _ZOXIDE_LANDED_AT=$SECONDS
  }
fi


# ═══════════════════════════ Yazi ═══════════════════════════

# SEE: https://yazi-rs.github.io/docs/quick-start#shell-wrapper
if (command -v yazi && ! command -v __yazi) &> /dev/null; then
  function __yazi() {
    local tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" cwd
    yazi "$@" --cwd-file="$tmp"
    # NOTE: `$PWD` as in the official `y` (yazi keeps symlinks); unlike it, reads via `cat` and checks `-n`, not `-d`.
    if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then cd -- "$cwd"; fi
    rm -f -- "$tmp"
  }
  alias yazi=__yazi f=__yazi
fi


# ═══════════════════════════ Stow ═══════════════════════════

if (command -v stow && ! command -v __stow) &> /dev/null; then
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
      if command -v "$binary" &> /dev/null; then __stow "$config" && echo_ok "Stowed configuration for $(echo_hl "$config")."; fi
    done
  }
fi
