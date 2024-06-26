# =============================================
# ======== Neovim
# =============================================
if command -v nvim &> /dev/null; then
  export VIM_CONFIG="$XDG_CONFIG_HOME/nvim"
  export EDITOR='nvim' VISUAL='nvim'
  alias vim=nvim

  # Mason binaries
  PATH="$XDG_DATA_HOME/nvim/mason/bin:$PATH"
else
  function __neovim_installer() {
    if command -v brew &> /dev/null; then
      # Clone neovim config
      git clone --depth=1 https://github.com/Fau818/nvim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
      # Install dependencies on Linux
      [[ "$(uname)" == 'Linux' ]] && sudo apt-get install -y language-pack-en-base kitty xclip gcc
      # Install dependencies
      brew install lua make node yarn ripgrep yazi lazygit
      brew install neovim
    else echo_red 'Not found: `brew` command'
    fi
  }
fi
