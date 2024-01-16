#!/bin/bash
# ****************************************************************************
# ******************** Install script for Ubuntu or MacOS ********************
# ****************************************************************************
# -----------------------------------
# -------- Homebrew
# -----------------------------------
# Aliyun Repository
function __homebrew_install_from_aliyun_repo() {
  export HOMEBREW_BREW_GIT_REMOTE="$HOMEBREW_ALIYUN_BREW_GIT_REMOTE"
  export HOMEBREW_CORE_GIT_REMOTE="$HOMEBREW_ALIYUN_CORE_GIT_REMOTE"
  export HOMEBREW_API_DOMAIN="$HOMEBREW_ALIYUN_API_DOMAIN"
  export HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_ALIYUN_BOTTLE_DOMAIN"
  /bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"
}


# -----------------------------------
# -------- Dotfile Puller
# -----------------------------------
# BUG: Network error in accessing github.
function __dotfile_puller() {
  export DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles")
  [ ! -e "$DOTFILE_PATH" ] && git clone --depth 1 https://github.com/Fau818/dotfiles.git "$DOTFILE_PATH"
}


# -----------------------------------
# -------- ZSH Init
# -----------------------------------
function __zsh_init_fau() {
  # Install stow
  (! command -v stow &> /dev/null) && echo "ERROR: Not found stow command!" && return 1

  # Set auto stow
  if (command -v stow && ! command -v __stow) &> /dev/null; then
    export DOTFILE_PATH=$([[ "$(uname)" == 'Darwin' ]] && echo "$HOME/Documents/Fau/dotfiles" || echo "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles")
    function __stow() {
      [[ -z "$1" ]] && echo "ERROE: Empty Package Name!" && return 0
      local name="$1"
      local dotfile_dir=$([[ -d "$DOTFILE_PATH/private/$name" ]] && echo "$DOTFILE_PATH/private" || echo "$DOTFILE_PATH")

      stow --dir="$dotfile_dir" --target="$HOME" --ignore='.DS_Store' "$name"
    }
    alias stow=__stow
  fi

  # Create symbol link for zsh
  __stow zsh
}
