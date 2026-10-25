# ╔══════════════════════════════════════════════════════════╗
# ║                        Installers                        ║
# ╚══════════════════════════════════════════════════════════╝

# The installers that `pinstall` lists and runs, and that `starter.sh` runs on a new machine:
#   zsh installers.zsh --list     the installers for this platform, one `<name>\t<description>` per line
#   zsh installers.zsh NAME...    run them in order; returns 1 if any failed
#
# Each one is an `install_<name>` function, listed in `INSTALLERS` below. It installs what is missing, says what it
# did, and returns 1 when it fails. Nothing is asked but the sudo password, when needed, and whether to retry
# Homebrew from a mirror.
# - With `INSTALLER_LOG_DIR` set, as `starter.sh` does, the tools' own output goes to logs there.
# - Without it, as in `pinstall`, that output shows as usual.
# IMPO: Linux means Ubuntu here; the apt steps are skipped where there's no `apt-get`.

CONFIG_DIR=${0:A:h:h}  # This zsh config, wherever it is linked from
source "$CONFIG_DIR/plugins/colorful_print.zsh"


# ┌──────────────────────────────────────────────────────────┐
# │                         Registry                         │
# └──────────────────────────────────────────────────────────┘

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
# │                         Helpers                          │
# └──────────────────────────────────────────────────────────┘

# IMPO: `starter.sh` keeps bash copies of `ask`, `as_root`, `sudo_ready`, `progress`, `quiet` and `apt_install`;
# \     change both together. Only this `quiet` also runs without a log directory.


# ─── Questions ──────────────────────────────────────────────
# Ask the yes/no question `$1`; returns 0 for yes.
# - `$2` is the answer to an empty reply: `y`, or `n` (the default).
# - With `INSTALLER_YES=1`, the answer is yes, and nothing is asked.
# - With no terminal, the answer is no.
function ask() {
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


# ─── Root ───────────────────────────────────────────────────
# Run a command as root; returns its status.
# - Already root (e.g. in Docker): runs it directly.
# - With sudo: through `sudo -n`, which fails rather than ask, since this may run out of sight in a log.
#   Call `sudo_ready` first, where a password prompt can be seen.
# - Without sudo: says so, and returns 1 without running it.
function as_root() {
  if (( EUID == 0 )); then "$@"
  elif (( $+commands[sudo] )); then sudo -n "$@"
  else echo_warn "Skipped $(echo_hl "$*"): it needs root, and $(echo_hl 'sudo') isn't available."; return 1
  fi
}

# Make sure `as_root` can use sudo from here on; returns 1 if sudo fails.
# - sudo needs no password (a NOPASSWD rule, or a password entered a moment ago): nothing to do.
# - Otherwise: asks for the password now.
# NOTE: Not `sudo -v` alone: that asks whenever any sudoers rule wants a password, even beside a NOPASSWD
# \     rule, as on Ubuntu cloud images (the `sudo` group's rule plus cloud-init's NOPASSWD one).
function sudo_ready() { sudo -n true 2> /dev/null || sudo -v }


# ─── Quiet Runs ─────────────────────────────────────────────
# Draw the last 5 lines of the log `$1`, dimmed, then put the cursor back on the first, for the next draw to replace.
# - A line shows only what follows its last `\r`, as a terminal shows a progress line that redraws itself.
# - Terminal codes (colors, cursor moves) are dropped, tabs become spaces, and lines are cut at 70 columns:
#   each of these could throw the redraw off.
function progress() {
  tail -c 2000 "$1" 2> /dev/null | awk -v n=5 '
    { sub(/\r+$/, ""); gsub(/\033\[[0-9;?]*[A-Za-z]/, ""); gsub(/\t/, " "); parts = split($0, part, "\r"); $0 = part[parts] }
    NF { last[++count] = $0 }
    END {
      first = count > n ? count - n + 1 : 1
      for (i = first; i < first + n; i++) printf "\r\033[K  \033[2m%.70s\033[0m\n", last[i]
      printf "\033[%dA", n
    }'
}

# Run a command without input; returns its status.
# - With `INSTALLER_LOG_DIR` set: its output goes to the log `$1` there, and on a terminal its last lines show as
#   progress while it runs (see `progress`). On failure, that log's last 10 lines are printed.
# - Without `INSTALLER_LOG_DIR`, as in `pinstall`: its output shows as usual.
# - It never waits for input out of sight: stdin is empty, git and ssh can't prompt, and `as_root` uses `sudo -n`.
# - Ctrl-C stops the whole run.
function quiet() {
  local log="$INSTALLER_LOG_DIR/$1.log" ret=0 pid; shift
  local -x GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh} -o BatchMode=yes"
  [[ -n "$INSTALLER_LOG_DIR" ]] || { "$@" < /dev/null; return }

  if [[ -t 1 ]]; then
    "$@" < /dev/null > "$log" 2>&1 &
    pid=$!
    # NOTE: A job started with `&` ignores Ctrl-C, so the trap stops the whole run itself;
    # \     otherwise apt could go on unseen and keep its lock.
    trap 'printf "\e[J"; kill -TERM 0' INT
    while kill -0 "$pid" 2> /dev/null; do progress "$log"; sleep 0.2; done
    trap - INT
    printf '\e[J'; wait "$pid" || ret=$?
  else "$@" < /dev/null > "$log" 2>&1 || ret=$?
  fi

  (( ret == 0 )) || { echo "  Last lines of $(echo_hl "$log"):"; tail -n 10 "$log" | sed 's/^/    /' }
  return "$ret"
}


# ─── Apt ────────────────────────────────────────────────────
# Install the apt packages in `$@` that aren't installed yet; returns 1, after saying why, when it can't.
# 1. Nothing missing: done.
# 2. Needs root: skipped when there is neither root nor sudo, or sudo fails.
# 3. `apt-get update`, once per run.
# 4. A dpkg left half-done, e.g. by Ctrl-C, is finished.
# 5. `apt-get install`.
# All of it runs quietly, and apt waits up to 5 minutes for another apt, such as a fresh VM's unattended upgrades.
function apt_install() {
  (( $+commands[apt-get] )) || { echo_warn "Skipped $(echo_hl "$*"): there's no $(echo_hl 'apt-get') here."; return 1 }

  local pkg
  local -a missing=()
  # NOTE: Not `dpkg -s`, which also passes a removed package that left its config files.
  for pkg in "$@"; do [[ "$(dpkg-query -W -f='${db:Status-Status}' "$pkg" 2> /dev/null)" == 'installed' ]] || missing+=("$pkg"); done
  (( ${#missing} )) || return 0
  (( EUID == 0 || $+commands[sudo] )) || { echo_warn "Skipped $(echo_hl "${missing[*]}"): $(echo_hl 'apt') needs root, and $(echo_hl 'sudo') isn't available."; return 1 }

  echo_info "Installing $(echo_hl "${missing[*]}") with $(echo_hl 'apt') ..."
  (( EUID == 0 )) || sudo_ready || { echo_warn "Skipped $(echo_hl "${missing[*]}"): $(echo_hl 'sudo') failed."; return 1 }
  # NOTE: `INSTALLER_APT_UPDATED` remembers the update; `starter.sh` passes its own on.
  if [[ "$INSTALLER_APT_UPDATED" != 1 ]]; then quiet apt-update as_root apt-get -o DPkg::Lock::Timeout=300 update && INSTALLER_APT_UPDATED=1; fi
  # NOTE: A dpkg left half-done (e.g. by Ctrl-C) blocks every install until it's finished: `dpkg --configure -a`
  # \     finishes an interrupted run, and `apt-get -f install` adds any dependencies it still lacks.
  if [[ -n "$(dpkg --audit 2> /dev/null)" ]]; then
    quiet dpkg-repair as_root env DEBIAN_FRONTEND=noninteractive sh -c 'dpkg --configure -a; apt-get -o DPkg::Lock::Timeout=300 -f install -y' || true
  fi
  [[ "$INSTALLER_APT_UPDATED" == 1 ]] && quiet "apt-$1" as_root env DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::Lock::Timeout=300 install -y "${missing[@]}" && return 0
  echo_warn "Could not install $(echo_hl "${missing[*]}") with $(echo_hl 'apt')."; return 1
}


# ─── Brew ───────────────────────────────────────────────────
# Put Homebrew on PATH if it's installed but not loaded yet, e.g. right after installing it; returns 1 without it.
function load_brew() {
  (( $+commands[brew] )) && return 0

  local prefix
  for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
    [[ -x "$prefix/bin/brew" ]] && { eval "$("$prefix/bin/brew" shellenv)"; return 0 }
  done
  return 1
}

# Install the Homebrew formulae in `$@` that aren't installed yet; returns 1 when brew fails or is missing.
# - Each formula is installed once, though the tool groups overlap.
# - Its log is named after the first formula, e.g. `brew-neovim.log`.
function brew_install() {
  load_brew || { echo_error "$(echo_hl 'Homebrew') is not installed; run $(echo_hl 'pinstall homebrew') first."; return 1 }

  local formula
  local -a formulae=(${(u)@}) installed=(${(f)"$(brew list --formula -1)"}) missing=()
  for formula in $formulae; do (( ${installed[(Ie)$formula]} )) || missing+=("$formula"); done
  (( ${#missing} )) || { echo_ok "Already installed: $(echo_hl "${formulae[*]}")"; return 0 }

  echo_info "Installing $(echo_hl "${missing[*]}") with $(echo_hl 'Homebrew') ..."
  # NOTE: Homebrew 7 asks before installing by default; this installer was already chosen, so don't ask twice.
  quiet "brew-$1" env HOMEBREW_NO_ASK=1 brew install "${missing[@]}"
}


# ─── Downloads ──────────────────────────────────────────────
# Download the script at `$2` and run it with bash, its output in the log `$1`; fails when either step does.
function run_remote() {
  local script
  script=$(curl -fsSL "$2") || { echo_error "Could not download $(echo_hl "$2")"; return 1 }
  quiet "$1" /bin/bash -c "$script"
}


# ┌──────────────────────────────────────────────────────────┐
# │                         Homebrew                         │
# └──────────────────────────────────────────────────────────┘

# ─── Sources ────────────────────────────────────────────────
# Run Homebrew's installer from the official source; returns its status.
function homebrew_official() {
  unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN
  run_remote homebrew https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
}

# Run Homebrew's installer through the Aliyun mirror; returns its status.
function homebrew_aliyun() {
  # NOTE: The mirror's addresses live in `plugins/homebrew.zsh`, which stops right after them while brew is missing.
  source "$CONFIG_DIR/plugins/homebrew.zsh"
  export HOMEBREW_BREW_GIT_REMOTE="$HOMEBREW_ALIYUN_BREW_GIT_REMOTE" HOMEBREW_CORE_GIT_REMOTE="$HOMEBREW_ALIYUN_CORE_GIT_REMOTE"
  export HOMEBREW_API_DOMAIN="$HOMEBREW_ALIYUN_API_DOMAIN" HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_ALIYUN_BOTTLE_DOMAIN"
  run_remote homebrew-aliyun https://gitee.com/ineo6/homebrew-install/raw/master/install.sh
}


# ─── Installer ──────────────────────────────────────────────
# Whether this runs in a container, by the same check as Homebrew's installer, which only lets root install inside one.
function in_container() {
  [[ -f /.dockerenv || -f /run/.containerenv ]] && return 0
  grep -qE 'azpl_job|actions_job|docker|garden|kubepods' /proc/1/cgroup 2> /dev/null
}

# Install Homebrew.
# 1. Already installed: done.
# 2. Linux only: as root, only inside a container, which is all Homebrew's installer allows; otherwise it needs
#    sudo or a writable /home/linuxbrew. Then the build tools Homebrew asks for, with apt.
# 3. sudo, asked for now if needed, since the installer runs non-interactively.
# 4. The official installer; when it fails, the Aliyun mirror's, if you agree.
# 5. Where Homebrew went, and how to load it into this shell.
function install_homebrew() {
  load_brew && { echo_ok "$(echo_hl 'Homebrew') is already installed at $(echo_hl "$(brew --prefix)")."; return 0 }

  if [[ "$(uname)" == 'Linux' ]]; then
    if (( EUID == 0 )) && ! in_container; then
      echo_error "$(echo_hl 'Homebrew') cannot be installed as root outside a container; run this as a normal user with $(echo_hl 'sudo')."; return 1
    fi
    (( EUID == 0 || $+commands[sudo] )) || [[ -w /home/linuxbrew ]] || { echo_error "$(echo_hl 'Homebrew') on Linux needs root or $(echo_hl 'sudo') to create $(echo_hl /home/linuxbrew)."; return 1 }
    # NOTE: Not git and curl, which fetched these dotfiles already, and nothing more, so no second gcc from
    # \     `brew install gcc`. Homebrew installs without them, so a failure here only warns.
    apt_install build-essential procps file
  fi

  # NOTE: No RETURN prompt, and `sudo -n` on the sudo asked for here.
  (( EUID == 0 )) || [[ -w /home/linuxbrew ]] || sudo_ready || { echo_error "Installing $(echo_hl 'Homebrew') needs $(echo_hl 'sudo')."; return 1 }
  export NONINTERACTIVE=1

  echo_info "Installing $(echo_hl 'Homebrew') from the official source; it takes a few minutes ..."
  if ! homebrew_official; then
    echo_warn 'Installing from the official source failed.'
    ask "Retry with the $(echo_hl 'Aliyun') mirror?" y || return 1
    echo_info "Installing $(echo_hl 'Homebrew') from the $(echo_hl 'Aliyun') mirror ..."
    homebrew_aliyun || { echo_error "Installing $(echo_hl 'Homebrew') failed."; return 1 }
  fi

  load_brew || { echo_error "$(echo_hl 'Homebrew') seems installed, but $(echo_hl 'brew') cannot be found."; return 1 }
  echo_ok "$(echo_hl 'Homebrew') installed at $(echo_hl "$(brew --prefix)"); run $(echo_hl 'exec zsh -l') to load it."
  # NOTE: Its Next steps add `brew shellenv` to `.zprofile`, which is the dotfiles' own and loads Homebrew already.
  [[ -n "$INSTALLER_LOG_DIR" ]] || echo_info "Skip Homebrew's $(echo_hl 'Next steps') above: the zsh config already loads it."
}


# ┌──────────────────────────────────────────────────────────┐
# │                          Tools                           │
# └──────────────────────────────────────────────────────────┘

# ─── CLI Tools ──────────────────────────────────────────────
# The shell basics the zsh config uses; not an installer of their own, they come with neovim or yazi.
CLI_TOOLS=(eza zoxide)


# ─── Neovim ─────────────────────────────────────────────────
# Install neovim and its tools with Homebrew, then clone nvim-config, unless a Neovim config is there already.
# NOTE: ImageMagick isn't offered: nvim says so itself the first time an image needs it; node is an installer of its own.
function install_neovim() {
  brew_install neovim fzf ripgrep fd lazygit git-delta "${CLI_TOOLS[@]}" || return 1

  local config="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -e "$config" ]]; then echo_ok "Neovim config already exists at $(echo_hl "$config"), left as is."
  else
    echo_info "Cloning $(echo_hl 'nvim-config') into $(echo_hl "$config") ..."
    quiet nvim-config git clone --depth=1 https://github.com/Fau818/nvim-config.git "$config" || return 1
  fi
}


# ─── Node ───────────────────────────────────────────────────
function install_node() { brew_install node }


# ─── Yazi ───────────────────────────────────────────────────
# NOTE: No preview helpers (ffmpeg, poppler, 7-Zip, ...): yazi names the missing one in its preview pane.
function install_yazi() { brew_install yazi zoxide bat ripgrep fd "${CLI_TOOLS[@]}" }


# ┌──────────────────────────────────────────────────────────┐
# │                        Linux Only                        │
# └──────────────────────────────────────────────────────────┘

# ─── Docker ─────────────────────────────────────────────────
# Install Docker Engine with get.docker.com's script, unless docker is there already.
function install_docker() {
  (( $+commands[docker] )) && { echo_ok "$(echo_hl 'Docker') is already installed: $(docker --version)"; return 0 }
  (( EUID == 0 || $+commands[sudo] )) || { echo_error "Installing $(echo_hl 'Docker') needs root or $(echo_hl 'sudo')."; return 1 }
  (( EUID == 0 )) || sudo_ready || return 1

  local script
  script=$(mktemp) || return 1
  {
    echo_info "Installing $(echo_hl 'Docker Engine') ..."
    curl -fsSL https://get.docker.com -o "$script" && quiet docker as_root sh "$script" || return 1
  } always { rm -f "$script" }
  echo_ok "$(echo_hl 'Docker') installed: $(docker --version)"
}


# ─── Miniconda ──────────────────────────────────────────────
# Install Miniconda into `~/.local/miniconda3`, unless it's in one of the places `plugins/python.zsh` looks for it.
function install_miniconda() {
  local dir
  for dir in "$HOME/miniconda3" "$HOME/.local/miniconda3" "${XDG_DATA_HOME:-$HOME/.local/share}/miniconda3" /usr/local/miniconda3; do
    [[ -d "$dir" ]] && { echo_ok "$(echo_hl 'Miniconda') is already installed at $(echo_hl "$dir")."; return 0 }
  done

  local prefix="$HOME/.local/miniconda3" script
  # NOTE: The Miniconda installer refuses to run unless its file name ends in `.sh`.
  script=$(mktemp --suffix=.sh) || return 1
  {
    echo_info "Installing $(echo_hl 'Miniconda') into $(echo_hl "$prefix") ..."
    curl -fsSL -o "$script" "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh" || return 1
    # NOTE: Batch mode skips `conda init`, which would append to the dotfiles' .zshrc; `python.zsh` loads conda itself.
    quiet miniconda bash "$script" -b -p "$prefix" || return 1
  } always { rm -f "$script" }
  echo_ok "$(echo_hl 'Miniconda') installed at $(echo_hl "$prefix"); run $(echo_hl 'exec zsh -l') to use $(echo_hl 'conda')."
}


# ┌──────────────────────────────────────────────────────────┐
# │                        Main Entry                        │
# └──────────────────────────────────────────────────────────┘

# ─── Platform ───────────────────────────────────────────────
OS=$([[ "$(uname)" == 'Darwin' ]] && echo 'macos' || echo 'linux')

# Whether installer `$1` exists and runs on this platform.
function runs_here() {
  (( ${${(k)INSTALLERS}[(Ie)$1]} )) || return 1
  local platform=${INSTALLERS[$1]%%|*}
  [[ "$platform" == 'all' || "$platform" == "$OS" ]]
}


# ─── Main ───────────────────────────────────────────────────
# `--list` prints the installers for this platform; otherwise the named ones run in order.
if [[ "$1" == '--list' ]]; then
  for name in ${(ok)INSTALLERS}; do runs_here "$name" && print -r -- "$name"$'\t'"${INSTALLERS[$name]#*|}"; done
  exit 0
fi

ret=0
for name in "$@"; do
  runs_here "$name" || { echo_error "No installer named $(echo_hl "$name") for this platform."; ret=1; continue }
  echo_info "Running installer: $(echo_hl "$name")"
  # NOTE: A subshell each, so an installer's `exit`, `cd` or variables don't reach the next one.
  ( "install_$name" ) || { echo_error "Installer $(echo_hl "$name") failed."; ret=1 }
done
exit "$ret"
