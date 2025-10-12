# =============================================
# ========== Homebrew
# =============================================
# ---------- Initialization
if ! command -v brew &> /dev/null; then
  # Make sure the `brew` command is available on Linux and Mac (Apple Chip)
  function ___homebrew_init() {
    local prefix=$([[ "$(uname)" == 'Linux' ]] && echo '/home/linuxbrew/.linuxbrew' || echo '/opt/homebrew')
    [[ -d "$prefix" ]] && eval "$("$prefix/bin/brew" shellenv)"
  }
  ___homebrew_init
else # eval "$(brew shellenv)"
fi


# ---------- Optional Package
if [[ -v HOMEBREW_PREFIX ]]; then
  [[ -d "$HOMEBREW_PREFIX/opt/llvm" ]]    && PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
  [[ -d "$HOMEBREW_PREFIX/opt/make" ]]    && PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
  [[ -d "$HOMEBREW_PREFIX/opt/openjdk" ]] && PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
fi



# =============================================
# ========== Neovim
# =============================================
if command -v nvim &> /dev/null; then
  export VIM_CONFIG="$XDG_CONFIG_HOME/nvim"
  export EDITOR='nvim' VISUAL='nvim'
  # Mason binaries
  PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
fi



# =============================================
# ========== Rust
# =============================================
if command -v rustup &> /dev/null; then PATH="$CARGO_HOME/bin:$PATH"; fi
