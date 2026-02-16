source "$ZPLUGINDIR/colorful_print.zsh"

PATH="$HOME/.local/bin:$PATH"

# ==================== Homebrew ====================
# ---------- Initialization
if ! command -v brew &> /dev/null; then
  # Make sure the `brew` command is available on Linux and Mac (Apple Chip)
  function ___homebrew_init() {
    local prefix=$([[ "$(uname)" == 'Linux' ]] && echo '/home/linuxbrew/.linuxbrew' || echo '/opt/homebrew')
    [[ -d "$prefix" ]] && eval "$("$prefix/bin/brew" shellenv)"
  }
  ___homebrew_init
else eval "$(brew shellenv)"  # Please enable this for setting env variables like `HOMEBREW_PREFIX`.
fi


# ---------- Optional Package
if [[ -v HOMEBREW_PREFIX ]]; then
  [[ -d "$HOMEBREW_PREFIX/opt/llvm" ]]    && PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
  [[ -d "$HOMEBREW_PREFIX/opt/make" ]]    && PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
  [[ -d "$HOMEBREW_PREFIX/opt/openjdk" ]] && PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
fi


# ==================== Neovim ====================
if command -v nvim &> /dev/null; then
  export VIM_CONFIG="$XDG_CONFIG_HOME/nvim"
  export EDITOR='nvim' VISUAL='nvim'
  # Mason binaries
  PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
fi


# ==================== Rust ====================
if command -v rustup &> /dev/null; then PATH="$CARGO_HOME/bin:$PATH"; fi

# ==================== Gem ====================
if command -v gem &> /dev/null; then PATH="$XDG_DATA_HOME/gem/bin:$PATH"; fi

# ==================== Orbstack ====================
[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh" 2> /dev/null

# ==================== VPN Auto Start (Linux Only) ====================
[[ "$(uname)" == 'Linux' ]] && source "$ZPLUGINDIR/vpn.zsh" && _auto_start_vpn
