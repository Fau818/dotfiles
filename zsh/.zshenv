# ════════════════════════════════════════════════════════════
# ══════════════════════════ Basic ═══════════════════════════
# ════════════════════════════════════════════════════════════

skip_global_compinit=1   # Skip Ubuntu global compinit


# ─── XDG Base Directory ─────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


# ─── Zsh Directory ──────────────────────────────────────────
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUGINDIR="$ZDOTDIR/plugins"
export ZSCRIPTDIR="$ZDOTDIR/scripts"
export HISTFILE="$ZDOTDIR/.zsh_history"


# ─── Shell and Terminal ─────────────────────────────────────
[[ ! -v SHELL ]] && export SHELL=$(command -v zsh)

# ┄┄┄ Kitty terminal
[[ -v KITTY_PID ]] && export TERM='xterm-kitty'

# ┄┄┄ Xterm
[[ ! -v TERM || "$TERM" == 'xterm' ]] && export TERM='xterm-256color'

# ┄┄┄ Language
[[ ! -v LANG ]] &&  export LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8' LC_CTYPE='en_US.UTF-8'


# ─── Personal Preference ────────────────────────────────────
# ┄┄┄ Dotfile path
export DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "$XDG_CONFIG_HOME/dotfiles")

# ┄┄┄ ICLOUD
if [[ "$(uname)" == 'Darwin' ]] then
  export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  export IBOOK="$HOME/Library/Mobile Documents/iCloud~com~apple~iBooks"
  export ISURGE="$HOME/Library/Mobile Documents/iCloud~com~nssurge~inc/Documents"
  export IOBSIDIAN="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Phoenix"
fi

# ┄┄┄ OpenAI
export OPENAI_API_PATH="$DOTFILE_PATH/private/openai"


# ════════════════════════════════════════════════════════════
# ═════════════════════════ Software ═════════════════════════
# ════════════════════════════════════════════════════════════

# ┄┄┄ Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
export HOMEBREW_NO_REQUIRE_TAP_TRUST=1

# ┄┄┄ Anaconda
export ANACONDA_CONFIG_TOML="$XDG_CONFIG_HOME/anaconda/config.toml"
export ANACONDA_AUTH_KEYRING_PATH="$XDG_DATA_HOME/anaconda/keyring"

# ┄┄┄ Claude
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"

# ┄┄┄ Codex
export CODEX_HOME="$XDG_CONFIG_HOME/codex"

# ┄┄┄ Codeium
export CODEIUM_HOME="$XDG_CONFIG_HOME/codeium"

# ┄┄┄ Conda
export CONDA_AUTO_ENVS_CONF="$DOTFILE_PATH/private/conda/conda_auto_envs.conf"
export CONDA_HOME="$XDG_CONFIG_HOME/conda"  # NOTE: This is not a standard conda variable, but a custom one for this setup.
export CONDA_PKGS_DIRS="$XDG_CACHE_HOME/conda/pkgs"
export CONDA_ENVS_DIRS="$XDG_DATA_HOME/conda/envs"
export CONDARC="$CONDA_HOME/condarc"
export CONDATOS="$CONDA_HOME/tos"
export CONDA_ANACONDA_ANON_USAGE=false
export CONDA_REGISTER_ENVS=false

# ┄┄┄ Copilot
export COPILOT_HOME="$XDG_CONFIG_HOME/copilot"

# ┄┄┄ Cpp
export CPPFLAGS_FAU='-std=c++17 -O2 -DCODE_Fau'
export CPLUS_INCLUDE_PATH="$XDG_CONFIG_HOME/clangd/include"

# ┄┄┄ Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# ┄┄┄ Fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'

# ┄┄┄ Gem
export GEM_HOME="$XDG_DATA_HOME/gem"

# ┄┄┄ Git
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"

# ┄┄┄ Less
export LESSHISTFILE="$XDG_STATE_HOME/less_history"

# ┄┄┄ Netrc
export NETRC="$XDG_CONFIG_HOME/netrc/netrc"

# ┄┄┄ Npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

# ┄┄┄ Python
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export IPYTHONDIR="$XDG_DATA_HOME/ipython"
export PIP_CACHE_DIR="$XDG_CACHE_HOME/pip"
export UV_PROJECT_ENVIRONMENT='venv.nosync'

export MPLCONFIGDIR="$XDG_CACHE_HOME/matplotlib"
export KAGGLE_CONFIG_DIR="$XDG_CONFIG_HOME/kaggle"
export SCIKIT_LEARN_DATA="$XDG_CACHE_HOME/scikit_learn_data"

export CLEARML_CONFIG_FILE="$XDG_CONFIG_HOME/clearml/clearml.conf"
export WANDB_CONFIG_DIR="$XDG_CONFIG_HOME/wandb"
# export HF_HOME="$XDG_CACHE_HOME/huggingface"
# export TORCH_HOME="$XDG_CACHE_HOME/torch"

# ┄┄┄ Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# ┄┄┄ Starship
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# ┄┄┄ Tldr
export TLDR_CACHE_DIR="$XDG_CACHE_HOME/tldr"

# ┄┄┄ Wakatime
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"

# ┄┄┄ Zoxide
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"


# ════════════════════════════════════════════════════════════
# ═══════════════════════════ TEST ═══════════════════════════
# ════════════════════════════════════════════════════════════

# [[ "$(uname)" == 'Darwin' && "$(uname -m)" == 'arm64' ]] && (ps aux | grep X11 &> /dev/null) && export DISPLAY=':0'

# export XAUTHORITY="$XDG_CACHE_HOME/Xauthority"  # IMPO: It's for routing x11 file.
