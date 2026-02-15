# =============================================
# ========== Constants
# =============================================
HOMEBREW_OFFICIAL_BREW_GIT_REMOTE='https://github.com/Homebrew/brew.git'
HOMEBREW_OFFICIAL_CORE_GIT_REMOTE='https://github.com/Homebrew/homebrew-core.git'

HOMEBREW_TSINGHUA_BREW_GIT_REMOTE='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git'
HOMEBREW_TSINGHUA_CORE_GIT_REMOTE='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git'
HOMEBREW_TSINGHUA_API_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api'
HOMEBREW_TSINGHUA_BOTTLE_DOMAIN='https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles'

HOMEBREW_ALIYUN_BREW_GIT_REMOTE='https://mirrors.aliyun.com/homebrew/brew.git'
HOMEBREW_ALIYUN_CORE_GIT_REMOTE='https://mirrors.aliyun.com/homebrew/homebrew-core.git'
HOMEBREW_ALIYUN_API_DOMAIN='https://mirrors.aliyun.com/homebrew-bottles/api'
HOMEBREW_ALIYUN_BOTTLE_DOMAIN='https://mirrors.aliyun.com/homebrew/homebrew-bottles'



# =============================================
# ========== Installer
# =============================================
# Install Homebrew (default: official source)
function __homebrew_install() {
  echo_info "Select Homebrew installation source:"
  echo "1) Official - https://github.com/Homebrew (default)"
  echo "2) Aliyun Mirror - https://mirrors.aliyun.com"
  read -r "choice?Please enter your choice (default is official): "
  choice="${choice:-1}"

  case "$choice" in
    1)
      echo_info "Installing from official source..."
      unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ;;
    2)
      echo_info "Installing from Aliyun mirror..."
      export HOMEBREW_BREW_GIT_REMOTE="$HOMEBREW_ALIYUN_BREW_GIT_REMOTE"
      export HOMEBREW_CORE_GIT_REMOTE="$HOMEBREW_ALIYUN_CORE_GIT_REMOTE"
      export HOMEBREW_API_DOMAIN="$HOMEBREW_ALIYUN_API_DOMAIN"
      export HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_ALIYUN_BOTTLE_DOMAIN"
      /bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"
      ;;
    *)
      echo_error "Invalid choice: $choice. Please run again and select 1 or 2."
      return 1
      ;;
  esac
}



# =============================================
# ========== Homebrew
# =============================================
# RETURN: if no binary file `brew`, return.
! command -v brew &> /dev/null && return 0

# Auto set bottle domain
function ___homebrew_auto_set_bottle_domain() {
  # Get repository url and force end with `.git`
  local homebrew_repo_url="$(git -C "$(brew --repo)" remote get-url origin)"
  [[ "$homebrew_repo_url" != *.git ]] && homebrew_repo_url="$homebrew_repo_url.git"
  # Determine repository type
  if [[ "$homebrew_repo_url" == "$HOMEBREW_OFFICIAL_BREW_GIT_REMOTE" ]]; then unset HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN
  elif [[ "$homebrew_repo_url" == "$HOMEBREW_TSINGHUA_BREW_GIT_REMOTE" ]]; then
    export HOMEBREW_API_DOMAIN="$HOMEBREW_TSINGHUA_API_DOMAIN"
    export HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_TSINGHUA_BOTTLE_DOMAIN"
  elif [[ "$homebrew_repo_url" == "$HOMEBREW_ALIYUN_BREW_GIT_REMOTE" ]]; then
    export HOMEBREW_API_DOMAIN="$HOMEBREW_ALIYUN_API_DOMAIN"
    export HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_ALIYUN_BOTTLE_DOMAIN"
  else echo_warn 'Unknown homebrew repo url, please set `HOMEBREW_BOTTLE_DOMAIN` manually.'
  fi
}
___homebrew_auto_set_bottle_domain


# ==================== Sourcer ====================
# Official Source
function __homebrew_set_official_source() {
  if command -v brew &> /dev/null; then
    git -C "$(brew --repo)" remote set-url origin "$HOMEBREW_OFFICIAL_BREW_GIT_REMOTE"
    # Set bottle domain
    ___homebrew_auto_set_bottle_domain
  else echo_error 'Not found: `brew` command'
  fi
}

# Tsinghua Source
function __homebrew_set_tsinghua_source() {
  if command -v brew &> /dev/null; then
    git -C "$(brew --repo)" remote set-url origin "$HOMEBREW_TSINGHUA_BREW_GIT_REMOTE"
    # Set bottle domain
    ___homebrew_auto_set_bottle_domain
  else echo_error 'Not found: `brew` command'
  fi
}

# Aliyun Source
function __homebrew_set_aliyun_source() {
  if command -v brew &> /dev/null; then
    git -C "$(brew --repo)" remote set-url origin "$HOMEBREW_ALIYUN_BREW_GIT_REMOTE"
    # Set bottle domain
    ___homebrew_auto_set_bottle_domain
  else echo_error 'Not found: `brew` command'
  fi
}
