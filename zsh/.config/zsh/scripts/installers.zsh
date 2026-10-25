# ╔══════════════════════════════════════════════════════════╗
# ║                        Installers                        ║
# ╚══════════════════════════════════════════════════════════╝

# Run by `pinstall`, and by `starter.sh` on a new machine:
#   zsh installers.zsh --list     the installers for this platform, one `<name>\t<description>` per line
#   zsh installers.zsh NAME...    run them in order; returns 1 if any failed
# IMPO: Linux means Ubuntu here; elsewhere the apt steps are skipped.

CONFIG_DIR=${0:A:h:h}  # This zsh config, wherever it is linked from
source "$CONFIG_DIR/plugins/colorful_print.zsh"


# ─── Registry ───────────────────────────────────────────────
# Name -> `platform|description`; the platform is all, linux or macos.
typeset -A INSTALLERS=(
  [homebrew]='all|Homebrew itself (official source; offers the Aliyun mirror if that fails)'
  [neovim]='all|Neovim and nvim-config, with fzf, ripgrep, fd, lazygit, git-delta, eza, zoxide'
  [node]='all|Node.js, which Copilot and the LSP servers installed through npm need'
  [yazi]='all|yazi, the terminal file manager, with zoxide, bat, ripgrep, fd, eza'
  [docker]='linux|Docker Engine from get.docker.com (needs root or sudo)'
  [miniconda]='linux|Miniconda into ~/.local/miniconda3 (no sudo needed)'
)


# ┌──────────────────────────────────────────────────────────┐
# │                     Helper Functions                     │
# └──────────────────────────────────────────────────────────┘

# IMPO: `starter.sh` keeps bash copies of `__ask`, `__as_root` and `__apt_install`; change both together.


# ─── Questions ──────────────────────────────────────────────
# Ask a yes/no question; returns 0 for yes.
# $2 is the default (y or n) for an empty reply. With no terminal the answer is no, unless `INSTALLER_YES=1` says yes to all.
function __ask() {
  local question=$1 default=${2:-n} hint='[y/N]' reply
  [[ "$default" == 'y' ]] && hint='[Y/n]'

  if [[ "$INSTALLER_YES" == 1 ]]; then echo "$question $hint y"; return 0; fi
  # NOTE: Read the terminal, not stdin, which may be a pipe.
  if ! { : < /dev/tty } 2> /dev/null; then echo "$question $hint n (no terminal)"; return 1; fi

  # NOTE: `read "reply?prompt"` only prints its prompt in interactive shells, so print it here.
  print -rn -- "$question $hint "
  read -r reply < /dev/tty
  [[ "${reply:-$default}" == [Yy]* ]]
}


# ─── Privileges ─────────────────────────────────────────────
# Run a command as root: directly when already root (e.g. in Docker), else through sudo.
# Returns 1 without running it when neither is possible.
function __as_root() {
  if (( EUID == 0 )); then "$@"
  elif (( $+commands[sudo] )); then sudo "$@"
  else echo_warn "Skipped $(echo_hl "$*"): it needs root, and sudo isn't available."; return 1
  fi
}


# ─── Packages ───────────────────────────────────────────────
# Install apt packages that aren't installed yet; returns 1, after saying why, when that isn't possible here or apt fails.
function __apt_install() {
  (( $+commands[apt-get] )) || { echo_warn "Skipped $(echo_hl "$*"): there's no $(echo_hl 'apt-get') here."; return 1 }

  local pkg
  local -a missing=()
  for pkg in "$@"; do dpkg -s "$pkg" &> /dev/null || missing+=("$pkg"); done
  (( ${#missing} )) || return 0
  (( EUID == 0 || $+commands[sudo] )) || { echo_warn "Skipped $(echo_hl "${missing[*]}"): apt needs root, and sudo isn't available."; return 1 }

  echo_info "Installing $(echo_hl "${missing[*]}") with apt..."
  __as_root apt-get update -qq && __as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}" && return 0
  echo_warn "Could not install $(echo_hl "${missing[*]}") with apt."; return 1
}

# Put Homebrew on PATH if it's installed but not loaded yet, e.g. right after installing it.
function __load_brew() {
  (( $+commands[brew] )) && return 0

  local prefix
  for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
    [[ -x "$prefix/bin/brew" ]] && { eval "$("$prefix/bin/brew" shellenv)"; return 0 }
  done
  return 1
}

# Install Homebrew formulae that aren't installed yet.
function __brew_install() {
  __load_brew || { echo_error "Homebrew is not installed; run $(echo_hl 'pinstall homebrew') first."; return 1 }

  local formula
  local -a formulae=(${(u)@}) installed=(${(f)"$(brew list --formula -1)"}) missing=()  # Unique: the tool groups overlap
  for formula in $formulae; do (( ${installed[(Ie)$formula]} )) || missing+=("$formula"); done
  (( ${#missing} )) || { echo_ok "Already installed: $(echo_hl "${formulae[*]}")"; return 0 }

  echo_info "Installing $(echo_hl "${missing[*]}") with Homebrew..."
  # NOTE: Homebrew 7 asks before installing by default; this installer was already chosen, so don't ask twice.
  HOMEBREW_NO_ASK=1 brew install "${missing[@]}"
}


# ─── Downloads ──────────────────────────────────────────────
# Download a script and run it with bash; fails when either step does.
function __run_remote() {
  local script
  script=$(curl -fsSL "$1") || { echo_error "Could not download $(echo_hl "$1")"; return 1 }
  /bin/bash -c "$script"
}


# ┌──────────────────────────────────────────────────────────┐
# │                         Homebrew                         │
# └──────────────────────────────────────────────────────────┘

# ─── Sources ────────────────────────────────────────────────
function __homebrew_official() {
  unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN
  __run_remote https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
}

function __homebrew_aliyun() {
  # NOTE: The mirror's addresses live in `plugins/homebrew.zsh`, which stops right after them while brew is missing.
  source "$CONFIG_DIR/plugins/homebrew.zsh"
  export HOMEBREW_BREW_GIT_REMOTE="$HOMEBREW_ALIYUN_BREW_GIT_REMOTE" HOMEBREW_CORE_GIT_REMOTE="$HOMEBREW_ALIYUN_CORE_GIT_REMOTE"
  export HOMEBREW_API_DOMAIN="$HOMEBREW_ALIYUN_API_DOMAIN" HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_ALIYUN_BOTTLE_DOMAIN"
  __run_remote https://gitee.com/ineo6/homebrew-install/raw/master/install.sh
}


# ─── Installer ──────────────────────────────────────────────
# Same container check as Homebrew's installer, which only lets root install inside one.
function __in_container() {
  [[ -f /.dockerenv || -f /run/.containerenv ]] && return 0
  grep -qE 'azpl_job|actions_job|docker|garden|kubepods' /proc/1/cgroup 2> /dev/null
}

function __install_homebrew() {
  # RETURN: Already installed.
  __load_brew && { echo_ok "Homebrew is already installed at $(echo_hl "$(brew --prefix)")."; return 0 }

  if [[ "$(uname)" == 'Linux' ]]; then
    # NOTE: Homebrew's own installer refuses root outside containers, and needs root or sudo for /home/linuxbrew.
    if (( EUID == 0 )) && ! __in_container; then
      echo_error 'Homebrew cannot be installed as root outside a container; run this as a normal user with sudo.'; return 1
    fi
    (( EUID == 0 || $+commands[sudo] )) || [[ -w /home/linuxbrew ]] || { echo_error "Homebrew on Linux needs root or sudo to create $(echo_hl /home/linuxbrew)."; return 1 }

    # The build tools Homebrew asks for on Linux; only these, so no second gcc from `brew install gcc`.
    # NOTE: Homebrew installs without them, so going on is fine when apt can't (it says why).
    __apt_install build-essential procps curl file git
  fi

  echo_info 'Installing Homebrew from the official source...'
  if ! __homebrew_official; then
    echo_warn 'Installing from the official source failed.'
    __ask 'Retry with the Aliyun mirror?' y || return 1
    echo_info 'Installing Homebrew from the Aliyun mirror...'
    __homebrew_aliyun || { echo_error 'Installing Homebrew failed.'; return 1 }
  fi

  __load_brew || { echo_error "Homebrew seems installed, but $(echo_hl 'brew') cannot be found."; return 1 }
  echo_ok "Homebrew installed at $(echo_hl "$(brew --prefix)")."
  echo_info "Skip Homebrew's $(echo_hl 'Next steps') above: the zsh config already loads it."
}


# ┌──────────────────────────────────────────────────────────┐
# │                          Tools                           │
# └──────────────────────────────────────────────────────────┘

# ─── CLI Tools ──────────────────────────────────────────────
# The shell basics the zsh config uses; not an installer of their own, they come with neovim or yazi.
CLI_TOOLS=(eza zoxide)


# ─── Neovim ─────────────────────────────────────────────────
# NOTE: ImageMagick isn't offered: nvim says so itself the first time an image needs it; node is an installer of its own.
function __install_neovim() {
  __brew_install neovim fzf ripgrep fd lazygit git-delta "${CLI_TOOLS[@]}" || return 1

  local config="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -e "$config" ]]; then echo_ok "Neovim config already exists at $(echo_hl "$config"), left as is."
  else
    echo_info "Cloning $(echo_hl 'nvim-config') into $(echo_hl "$config")..."
    git clone --depth=1 https://github.com/Fau818/nvim-config.git "$config" || return 1
  fi
}


# ─── Node ───────────────────────────────────────────────────
function __install_node() { __brew_install node }


# ─── Yazi ───────────────────────────────────────────────────
# NOTE: No preview helpers (ffmpeg, poppler, 7-Zip, ...): yazi names the missing one in its preview pane.
function __install_yazi() { __brew_install yazi zoxide bat ripgrep fd "${CLI_TOOLS[@]}" }


# ┌──────────────────────────────────────────────────────────┐
# │                        Linux Only                        │
# └──────────────────────────────────────────────────────────┘

# ─── Docker ─────────────────────────────────────────────────
function __install_docker() {
  # RETURN: Already installed.
  (( $+commands[docker] )) && { echo_ok "Docker is already installed: $(docker --version)"; return 0 }
  (( EUID == 0 || $+commands[sudo] )) || { echo_error 'Installing Docker needs root or sudo.'; return 1 }

  local script
  script=$(mktemp) || return 1
  {
    curl -fsSL https://get.docker.com -o "$script" && __as_root sh "$script" || return 1
  } always { rm -f "$script" }
  echo_ok "Docker installed: $(docker --version)"
}


# ─── Miniconda ──────────────────────────────────────────────
function __install_miniconda() {
  # RETURN: Already in one of the places `plugins/python.zsh` looks for conda on Linux.
  local dir
  for dir in "$HOME/miniconda3" "$HOME/.local/miniconda3" "${XDG_DATA_HOME:-$HOME/.local/share}/miniconda3" /usr/local/miniconda3; do
    [[ -d "$dir" ]] && { echo_ok "Miniconda is already installed at $(echo_hl "$dir")."; return 0 }
  done

  local prefix="$HOME/.local/miniconda3" script
  # NOTE: The Miniconda installer refuses to run unless its file name ends in `.sh`.
  script=$(mktemp --suffix=.sh) || return 1
  {
    curl -fsSL -o "$script" "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh" || return 1
    # NOTE: Batch mode skips `conda init`, which would append to the dotfiles' .zshrc; `python.zsh` loads conda itself.
    bash "$script" -b -p "$prefix" || return 1
  } always { rm -f "$script" }
  echo_ok "Miniconda installed at $(echo_hl "$prefix"); open a new shell to use $(echo_hl 'conda')."
}


# ┌──────────────────────────────────────────────────────────┐
# │                        Main Entry                        │
# └──────────────────────────────────────────────────────────┘

# ─── Platform ───────────────────────────────────────────────
OS=$([[ "$(uname)" == 'Darwin' ]] && echo 'macos' || echo 'linux')

# Whether installer $1 exists and runs on this platform.
function __runs_here() {
  (( ${${(k)INSTALLERS}[(Ie)$1]} )) || return 1
  local platform=${INSTALLERS[$1]%%|*}
  [[ "$platform" == 'all' || "$platform" == "$OS" ]]
}


# ─── Main ───────────────────────────────────────────────────
if [[ "$1" == '--list' ]]; then
  for name in ${(ok)INSTALLERS}; do __runs_here "$name" && print -r -- "$name"$'\t'"${INSTALLERS[$name]#*|}"; done
  exit 0
fi

ret=0
for name in "$@"; do
  # CASE: Unknown, or written for the other platform.
  __runs_here "$name" || { echo_error "No installer named $(echo_hl "$name") for this platform."; ret=1; continue }
  echo_info "Running installer: $(echo_hl "$name")"
  # NOTE: A subshell each, so an installer's `exit`, `cd` or variables don't reach the next one.
  ( "__install_$name" ) || { echo_error "Installer $(echo_hl "$name") failed."; ret=1 }
done
exit "$ret"
