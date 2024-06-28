#!/bin/bash
# ****************************************************************************
# ******************** Install script for Ubuntu or MacOS ********************
# ****************************************************************************
# -----------------------------------
# -------- Dotfile Puller
# -----------------------------------
# BUG: Network error in accessing github.
function __dotfile_puller() {
  DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles")
  [[ ! -e "$DOTFILE_PATH" ]] && git clone --depth 1 https://github.com/Fau818/dotfiles.git "$DOTFILE_PATH"
}


# -----------------------------------
# -------- ZSH Init
# -----------------------------------
function __zsh_init_fau() {
  # Detect stow
  (! command -v stow &> /dev/null) && echo "ERROR: Not found stow command!" && return 1
  # Create symbol link for zsh
  DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles")
  stow --dir="$DOTFILE_PATH" --target="$HOME" --ignore='.DS_Store' zsh
}


# -----------------------------------
# -------- Homebrew Install Packages
# -----------------------------------
function __brew_install_packages() {
  if [[ "$(uname)" == 'Linux' ]]; then
    brew install gcc
    brew install zoxide yazi lazygit
    brew install lua make ripgrep node yarn xclip
    brew install neovim
  fi
}
