# =============================================
# ======== Gadgets (Tools)
# =============================================
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
