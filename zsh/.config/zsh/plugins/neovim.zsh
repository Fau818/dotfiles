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
      [[ "$(uname)" == 'Linux' ]] && sudo apt-get install -y sudo curl git language-pack-en-base zsh stow kitty-terminfo rsync xclip build-essential
      # Install dependencies
      brew install zoxide yazi lazygit lua ripgrep fd neovim
    else echo_red 'Not found: `brew` command'
    fi
  }
fi
