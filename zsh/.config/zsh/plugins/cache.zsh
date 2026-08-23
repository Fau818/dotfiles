# ════════════════════════════════════════════════════════════
# ══════════════════════════ Cache ═══════════════════════════
# ════════════════════════════════════════════════════════════

[[ -v ZCACHEDIR ]] || return 1


# ─── Cached Eval ────────────────────────────────────────────
# Cache a tool's shell glue instead of re-running the tool on every startup.
# Regenerates when the binary is newer than the cache; a missing tool is a no-op.
#
#   cached_eval <tool> <args...>
function cached_eval() {
  (( $+commands[$1] )) || return 0

  local bin="$commands[$1]" cache="$ZCACHEDIR/$1.zsh"

  if [[ ! -s "$cache" || "$bin" -nt "$cache" ]]; then
    mkdir -p "${cache:h}" && "$@" > "$cache" || { rm -f "$cache"; return 1 }
  fi

  source "$cache"
}


# ─── Cached Compdef ─────────────────────────────────────────
# Same, for generators that emit a `#compdef` script: it lands in `$fpath`
# for compinit to autoload on first completion, so startup reads nothing.
#
#   cached_compdef <command> <generator...>
function cached_compdef() {
  local name="$1"
  shift
  (( $+commands[$1] )) || return 0

  local bin="$commands[$1]" file="$ZCACHEDIR/completions/_$name"
  [[ -s "$file" && ! "$bin" -nt "$file" ]] && return 0

  mkdir -p "${file:h}" && "$@" > "$file" || { rm -f "$file"; return 1 }
  rm -f "${ZDOTDIR:-$HOME}"/.zcompdump*(N)  # compinit trusts its dump (`-C`), so drop it.
}
