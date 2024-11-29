# =============================================
# ======== Installer
# =============================================
# -----------------------------------
# -------- Installer for Linux
# -----------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  # Apt source
  function __apt_set_aliyun_source() {
    local file_path='/etc/apt/sources.list'
    sudo mv $file_path '/etc/apt/sources.list.bak'
    sudo touch $file_path
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse'           >  '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse'  >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse'   >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse'  >> '$file_path'"
    sudo sh -c "echo 'deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse' >> '$file_path'"
  }

  # Utils Installer
  function __utils_installer() {
    brew install bat btop fzf lazygit neofetch tldr tree yazi zoxide
    sudo apt-get install -y rsync stow wget
  }

  # Docker
  alias __docker_installer='curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh && rm ./get-docker.sh'
  # Miniconda
  alias __miniconda_installer='curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda_installer.sh && \
  bash ./miniconda_installer.sh && rm ./miniconda_installer.sh'
  # alias __fix_opencv_error='sudo apt-get install -y libgl1-mesa-glx libglib2.0-0'
fi


# -----------------------------------
# -------- Nerd Font Installer
# -----------------------------------
function __nerd_font_installer() {
  if [[ "$(uname)" == 'Darwin' ]]; then
    # Check dependency
    (! command -v brew) && echo_red 'Homebrew is not installed.' && return 1

    echo_blue 'Running Mac installation...'
    # Install SF Mono Nerd Font
    brew tap shaunsingh/SFMono-Nerd-Font-Ligaturized && brew install font-sf-mono-nerd-font-ligaturized
    # Install Victor Mono Nerd Font
    brew install font-victor-mono-nerd-font
  elif [[ "$(uname)" == 'Linux' ]]; then
    # NOTE: This script isn't tested; maybe `VictorMono` doesn't work. [Solution: move them to fonts folder]
    echo_blue 'Running Linux installation...'

    local font_path="$HOME/.local/share/fonts"
    [[ ! -d "$font_path" ]] && mkdir -p "$font_path"
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
