# =============================================
# ======== Homebrew
# =============================================
# -----------------------------------
# -------- Initialization
# -----------------------------------
# Auto set bottle domain
function ___homebrew_auto_set_bottle_domain() {
  local HOMEBREW_TSINGHUA_BOTTLE_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git'
  local HOMEBREW_OFFICIAL_BOTTLE_DOMAIN='https://github.com/Homebrew/brew.git'
  local homebrew_repo_url="$(git -C "$(brew --repo)" remote get-url origin)"
  if [ "$homebrew_repo_url" = "$HOMEBREW_TSINGHUA_BOTTLE_DOMAIN" ]; then
    export HOMEBREW_BOTTLE_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles'
  elif [ "$homebrew_repo_url" = "$HOMEBREW_OFFICIAL_BOTTLE_DOMAIN" ]; then unset HOMEBREW_BOTTLE_DOMAIN
  else echo_yellow 'Unknown homebrew repo url, please set `HOMEBREW_BOTTLE_DOMAIN` manually.'
  fi
}

if command -v brew &> /dev/null; then
  [ ! -v HOMEBREW_PREFIX ] && export HOMEBREW_PREFIX="$(brew --prefix)"
  # Set bottle domain
  ___homebrew_auto_set_bottle_domain
  # Completion
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi


# -----------------------------------
# -------- Installer
# -----------------------------------
if ! command -v brew &> /dev/null; then
  # Official Repository
  function __homebrew_install_from_official_repo() {
    unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }

  # Tsinghua Repository
  function __homebrew_install_from_tsinghua_repo() {
    if [ "$(uname)" = 'Darwin' ]; then export HOMEBREW_CORE_GIT_REMOTE='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git'
    else export HOMEBREW_CORE_GIT_REMOTE='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/linuxbrew-core.git'
    fi
    export HOMEBREW_BREW_GIT_REMOTE='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git'
    export HOMEBREW_API_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api'
    export HOMEBREW_BOTTLE_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles'
    /bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"
  }
fi


# -----------------------------------
# -------- Source
# -----------------------------------
if command -v brew &> /dev/null; then
  # Official Source
  function __homebrew_set_official_source() {
    if command -v brew &> /dev/null; then
      local brew_repo_path="$(brew --repo)"
      local brew_repo_core_path="$(brew --repo homebrew/core)"
      local brew_repo_cask_path="$(brew --repo homebrew/cask)"
      [ -d "$brew_repo_path" ]      && git -C "$brew_repo_path"       remote set-url origin https://github.com/Homebrew/brew.git
      [ -d "$brew_repo_core_path" ] && git -C "$brew_repo_core_path"  remote set-url origin https://github.com/Homebrew/homebrew-core.git
      [ -d "$brew_repo_cask_path" ] && git -C "$brew_repo_cask_path"  remote set-url origin https://github.com/Homebrew/homebrew-cask.git

      # Set bottle domain
      ___homebrew_auto_set_bottle_domain
    else echo_red 'Not found: `brew` command'
    fi
  }

  # Tsinghua Source
  function __homebrew_set_tsinghua_source() {
    if command -v brew &> /dev/null; then
      local brew_repo_path="$(brew --repo)"
      local brew_repo_core_path="$(brew --repo homebrew/core)"
      local brew_repo_cask_path="$(brew --repo homebrew/cask)"
      [ -d "$brew_repo_path" ]      && git -C "$brew_repo_path"      remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
      [ -d "$brew_repo_core_path" ] && git -C "$brew_repo_core_path" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
      [ -d "$brew_repo_cask_path" ] && git -C "$brew_repo_cask_path" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git

      # Set bottle domain
      ___homebrew_auto_set_bottle_domain
    else echo_red 'Not found: `brew` command'
    fi
  }
fi
