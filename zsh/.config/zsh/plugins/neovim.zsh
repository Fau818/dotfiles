# =============================================
# ======== Neovim
# =============================================
if command -v nvim &> /dev/null; then
  export SUDO_EDITOR="$(whence -p nvim)"

  # NOTE: cwd-on-exit, like `utils.zsh`'s yazi wrapper; `NVIM_CWD_FILE` is read by an autocmd in `lua/fau/autocmd.lua`.
  function __nvim() {
    local tmp="$(mktemp -t "nvim-cwd.XXXXXX")"
    NVIM_CWD_FILE="$tmp" command nvim "$@"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$(pwd -P)" ]; then cd -- "$cwd"; fi
    rm -f -- "$tmp"
  }
  alias vim=__nvim nvim=__nvim
else
  function __neovim_installer() {
    if command -v brew &> /dev/null; then
      # Clone neovim config
      git clone --depth=1 https://github.com/Fau818/nvim-config.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
      # Install dependencies on Linux
      [[ "$(uname)" == 'Linux' ]] && sudo apt-get install -y sudo curl git language-pack-en-base zsh stow kitty-terminfo rsync xclip build-essential
      # Install dependencies
      brew install zoxide yazi lazygit lua ripgrep fd neovim
    else echo_error 'Not found: `brew` command'
    fi
  }
fi
