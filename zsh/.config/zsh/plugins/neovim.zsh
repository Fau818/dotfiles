# =============================================
# ======== Neovim
# =============================================
if command -v nvim &> /dev/null; then
  alias vim=nvim
else
  function __neovim_installer() {
    if command -v brew &> /dev/null; then
      # Clone neovim config
      git clone --depth=1 https://github.com/Fau818/nvim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
      # Install dependencies on Linux
      [[ "$(uname)" == 'Linux' ]] && sudo apt-get install -y language-pack-en-base kitty xclip gcc
      # Install dependencies
      brew install lua fd make node yarn ripgrep yazi lazygit
      brew install neovim
    else echo_red 'Not found: `brew` command'
    fi
  }
fi
