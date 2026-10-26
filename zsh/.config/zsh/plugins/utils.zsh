# ╔══════════════════════════════════════════════════════════╗
# ║                          Utils                           ║
# ╚══════════════════════════════════════════════════════════╝

# ══════════════════════════ Zoxide ══════════════════════════

if (( $+commands[zoxide] )); then
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
if (( $+commands[yazi] && ! $+functions[__yazi] )); then
  function __yazi() {
    local tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" cwd
    yazi "$@" --cwd-file="$tmp"
    # NOTE: `$PWD` as in the official `y` (yazi keeps symlinks); unlike it, reads via `cat` and checks `-n`, not `-d`.
    if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then cd -- "$cwd"; fi
    rm -f -- "$tmp"
  }
  alias yazi=__yazi f=__yazi
fi
