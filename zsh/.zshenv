# =============================================
# ======== Basic
# =============================================
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
[ ! -v SHELL ] && export SHELL=$(which zsh)

# Kitty terminal
[ -v KITTY_PID ] && export TERM='xterm-kitty'
[ "$(uname)" = 'Linux' ] && command -v kitty &> /dev/null && export TERM='xterm-kitty'
# Xterm
([ ! -v TERM ] || [ "$TERM" = 'xterm' ]) && export TERM='xterm-256color'

# Language
export LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8' LC_CTYPE='en_US.UTF-8'


# -----------------------------------
# -------- Personal Preference
# -----------------------------------
# Dotfile path
export DOTFILE_PATH=$([ "$(uname)" = 'Darwin' ] && echo "$HOME/Documents/Fau/dotfiles" || echo "$XDG_CONFIG_HOME/dotfiles")
# ICLOUD
[ "$(uname)" = 'Darwin' ] && export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
# Copilot
export COPILOT_ENABLE=$([ -f "$XDG_CONFIG_HOME/github-copilot/hosts.json" ] && echo 1 || echo 0)
# OpenAI
export OPENAI_API_PATH="$DOTFILE_PATH/private/openai"



# =============================================
# ======== Software
# =============================================
# -----------------------------------
# -------- Python
# -----------------------------------
export IPYTHONDIR="$XDG_CACHE_HOME/ipython"
export KAGGLE_CONFIG_DIR="$XDG_CONFIG_HOME/kaggle"
export CLEARML_CONFIG_FILE="$XDG_CONFIG_HOME/clearml/clearml.conf"
export MPLCONFIGDIR="$XDG_CACHE_HOME/matplotlib"
export PIP_CACHE_DIR="$XDG_CACHE_HOME/pip"


# -----------------------------------
# -------- Lunarvim
# -----------------------------------
PATH="$HOME/.local/bin:$PATH"


# -----------------------------------
# -------- MISC
# -----------------------------------
# Cpp
export CPPFLAGS_FAU='-std=c++17 -O2 -DCODE_Fau'
# Docker (FIXME: not working)
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
# Less
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
# Npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# Git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"
# TLDR
export TLDR_CACHE_DIR="$XDG_DATA_HOME/tldr"
# Wakatime
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
# Wget
export WGET_HSTS_FILE="$XDG_CACHE_HOME/wget-hsts"
# Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
