# =============================================
# ======== Basic
# =============================================
skip_global_compinit=1   # Skip Ubuntu global compinit
# -----------------------------------
# -------- XDG Base Directory
# -----------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


# -----------------------------------
# -------- Zsh Directory
# -----------------------------------
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUGINDIR="$ZDOTDIR/plugins"
export ZSCRIPTDIR="$ZDOTDIR/scripts"
export HISTFILE="$ZDOTDIR/.zsh_history"


# -----------------------------------
# -------- Shell and Terminal
# -----------------------------------
[[ ! -v SHELL ]] && export SHELL=$(which zsh)

# Kitty terminal
[[ -v KITTY_PID ]] && export TERM='xterm-kitty'
[[ "$(uname)" == 'Linux' ]] && command -v kitty &> /dev/null && export TERM='xterm-kitty'
# Xterm
[[ ! -v TERM || "$TERM" == 'xterm' ]] && export TERM='xterm-256color'

# Language
[[ ! -v LANG ]] &&  export LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8' LC_CTYPE='en_US.UTF-8'


# -----------------------------------
# -------- Personal Preference
# -----------------------------------
# Dotfile path
export DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "$XDG_CONFIG_HOME/dotfiles")
# ICLOUD
if [[ "$(uname)" == 'Darwin' ]] then
  export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  export IBOOK="$HOME/Library/Mobile Documents/iCloud~com~apple~iBooks"
  export ISURGE="$HOME/Library/Mobile Documents/iCloud~com~nssurge~inc/Documents"
  export IOBSIDIAN="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Phoenix"
fi
# OpenAI
export OPENAI_API_PATH="$DOTFILE_PATH/private/openai"



# =============================================
# ======== Software
# =============================================
# -----------------------------------
# -------- Homebrew
# -----------------------------------
# Disable AUTO_UPDATE
export HOMEBREW_NO_AUTO_UPDATE=1


# -----------------------------------
# -------- Python
# -----------------------------------
export IPYTHONDIR="$XDG_CACHE_HOME/ipython"
export KAGGLE_CONFIG_DIR="$XDG_CONFIG_HOME/kaggle"
export CLEARML_CONFIG_FILE="$XDG_CONFIG_HOME/clearml/clearml.conf"
export MPLCONFIGDIR="$XDG_CACHE_HOME/matplotlib"
export PIP_CACHE_DIR="$XDG_CACHE_HOME/pip"


# -----------------------------------
# -------- MISC
# -----------------------------------
# Claude
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
# Codex
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
# Codium
export CODEIUM_HOME="$XDG_CONFIG_HOME/codeium"
# Cpp
export CPPFLAGS_FAU='-std=c++17 -O2 -DCODE_Fau'
export CPLUS_INCLUDE_PATH="$XDG_CONFIG_HOME/clangd/include"
# Docker (FIXME: not working)
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
# Fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'
# Gem
export GEM_HOME="$XDG_DATA_HOME/gem"
# Git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"
# Less
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
# Npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# Starship
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
# TLDR
export TLDR_CACHE_DIR="$XDG_DATA_HOME/tldr"
# Wakatime
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"



# =============================================
# ======== TEST
# =============================================
# [[ "$(uname)" == 'Darwin' && "$(uname -m)" == 'arm64' ]] && (ps aux | grep X11 &> /dev/null) && export DISPLAY=':0'

export XAUTHORITY="$XDG_CACHE_HOME/Xauthority"
