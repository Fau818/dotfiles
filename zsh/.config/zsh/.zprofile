# =============================================
# ======== ZSH Profile
# =============================================
# -----------------------------------
# -------- Plugins
# -----------------------------------
source "$ZDOTDIR/utils.zsh"


# -----------------------------------
# -------- Homebrew
# -----------------------------------
# Make sure the `brew` command is available on Linux
if [ "$(uname)" = 'Linux' ] && ! command -v brew &> /dev/null; then
  [ -d '/home/linuxbrew' ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
command -v brew &> /dev/null && export HOMEBREW_PREFIX="$(brew --prefix)"

# Mason
if [ -v HOMEBREW_PREFIX ]; then
  [ -d "$HOMEBREW_PREFIX/opt/python@3.10" ] && PATH="$HOMEBREW_PREFIX/opt/python@3.10/libexec/bin:$PATH"
  [ -d "$HOMEBREW_PREFIX/opt/llvm" ]        && PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
  [ -d "$HOMEBREW_PREFIX/opt/make" ]        && PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
  [ -d "$HOMEBREW_PREFIX/opt/openjdk" ]     && PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
fi


# -----------------------------------
# -------- Neovim
# -----------------------------------
# Mason
[ -d "$XDG_DATA_HOME/nvim/mason/bin" ] && PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
