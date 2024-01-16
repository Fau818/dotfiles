# =============================================
# ======== Utility Functions
# =============================================
# -----------------------------------
# -------- Colorful Print
# -----------------------------------
function echo_black()  { echo "\e[90m$1\e[0m" }
function echo_red()    { echo "\e[91m$1\e[0m" }
function echo_green()  { echo "\e[92m$1\e[0m" }
function echo_yellow() { echo "\e[93m$1\e[0m" }
function echo_blue()   { echo "\e[94m$1\e[0m" }
function echo_purple() { echo "\e[95m$1\e[0m" }
function echo_cyan()   { echo "\e[96m$1\e[0m" }
function echo_white()  { echo "\e[97m$1\e[0m" }


# -----------------------------------
# -------- Apt Source
# -----------------------------------
if [ "$(uname)" = 'Linux' ]; then
  function __apt_set_ali_source() {
    local file_path='/etc/apt/sources.list'
    sudo mv $file_path '/etc/apt/sources.list.bak'
    sudo touch $file_path
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse'           >  '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse'  >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse'   >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse'  >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse' >> '$file_path'"
  }

  alias __get_docker='curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh && rm ./get-docker.sh'

  alias __get_miniconda='curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda_installer.sh && \
  sh ./miniconda_installer.sh && rm ./miniconda_installer.sh'

  alias __fix_opencv_error='sudo apt-get install -y libgl1-mesa-glx libglib2.0-0'
fi


# -----------------------------------
# -------- Nerd Font Installer
# -----------------------------------
function __nerd_font_install() {
  if [ "$(uname)" = 'Darwin' ]; then
    # Check dependency
    (! command -v brew) && echo_red 'Homebrew is not installed.' && return 1

    echo_blue 'Running Mac installation...'
    # Install SF Mono Nerd Font
    brew tap shaunsingh/SFMono-Nerd-Font-Ligaturized && brew install font-sf-mono-nerd-font-ligaturized
    # Install Victor Mono Nerd Font
    brew tap homebrew/cask-fonts && brew install font-victor-mono-nerd-font
  elif [ "$(uname)" = 'Linux' ]; then
    # NOTE: This script isn't tested; maybe `VictorMono` doesn't work. [Solution: move them to fonts folder]
    echo_blue 'Running Linux installation...'

    local font_path="$HOME/.local/share/fonts"
    [ ! -d "$font_path"] && mkdir -p "$font_path"
    # Install SF Mono Nerd Font
    git clone --depth=1 https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git && \
    mv "./SFMono-Nerd-Font-Ligaturized/*.otf" "$font_path" && rm -rf ./SFMono-Nerd-Font-Ligaturized
    # Install Victor Mono Nerd Font
    brew tap homebrew/linux-fonts && brew install homebrew/linux-fonts/font-victor-mono-nerd-font
  else
    echo_red "Unsupported operating system: $OSTYPE"
    return 1
  fi
}


# -----------------------------------
# -------- Dotfile Puller
# -----------------------------------
# NOTE: WIP...
function __dotfile_puller() {
  export DOTFILE_PATH=$([ "$(uname)" = 'Darwin' ] && echo "$HOME/Documents/Fau/dotfiles" || echo "$XDG_CONFIG_HOME/dotfiles")
  [ ! -e "$DOTFILE_PATH" ] && git clone --depth 1 https://github.com/Fau818/dotfiles.git "$DOTFILE_PATH"
  # stow='stow --dir="$DOTFILE_PATH" --target="$HOME" --ignore=".DS_Store"'
}



# =============================================
# ======== VPN
# =============================================
# -----------------------------------
# -------- VPN Setter
# -----------------------------------
function vpn() {
  if [ "$1" = 'start' ]; then
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    echo_yellow 'VPN is enabled.'
    return 0
  fi

  if [ ! -v https_proxy ]; then
    export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    echo_yellow 'VPN is enabled.'
  else
    unset https_proxy http_proxy all_proxy
    echo_yellow 'VPN is disabled.'
  fi
}

# Quick Start VPN on Linux
if [ "$(uname)" = 'Linux' ]; then
  function startClash() {
    # Check `clash` command
    (! command -v clash &> /dev/null) && echo_red 'Not found: `clash` command' && return 1
    # Start clash
    (pgrep -x clash &> /dev/null && echo_yellow 'Clash is already running!') || nohup clash > /dev/null &
    # Start VPN
    vpn start
  }
fi


# -----------------------------------
# -------- Autostart
# -----------------------------------
if [ "$(uname)" = 'Darwin' ]; then vpn start
elif [ "$(uname)" = 'Linux' ]; then pgrep -x clash &> /dev/null && vpn start
else echo_red 'Not supported: Unknown OS, auto start VPN failed.'
fi
