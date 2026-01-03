# =============================================
# ======== Installer
# =============================================
# -----------------------------------
# -------- Installer for Linux
# -----------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  # Docker
  alias __docker_installer='curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh && rm ./get-docker.sh'

  # Miniconda
  function __miniconda_installer() {
    local arch=$(uname -m)
    local url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${arch}.sh"
    curl -o miniconda_installer.sh "$url" && bash miniconda_installer.sh && rm miniconda_installer.sh
  }
  # alias __fix_opencv_error='sudo apt-get install -y libgl1-mesa-glx libglib2.0-0'
fi


# -----------------------------------
# -------- Nerd Font Installer
# -----------------------------------
function __nerd_font_installer() {
  if [[ "$(uname)" == 'Darwin' ]]; then
    # Check dependency
    (! command -v brew) && echo_error 'Homebrew is not installed.' && return 1

    echo_info 'Running Mac installation...'
    # Install SF Mono Nerd Font
    brew tap shaunsingh/SFMono-Nerd-Font-Ligaturized && brew install font-sf-mono-nerd-font-ligaturized
    # Install Victor Mono Nerd Font
    brew install font-victor-mono-nerd-font
  elif [[ "$(uname)" == 'Linux' ]]; then
    # NOTE: This script isn't tested; maybe `VictorMono` doesn't work. [Solution: move them to fonts folder]
    echo_info 'Running Linux installation...'

    local font_path="$HOME/.local/share/fonts"
    [[ ! -d "$font_path" ]] && mkdir -p "$font_path"
    # Install SF Mono Nerd Font
    git clone --depth=1 https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git && \
    mv "./SFMono-Nerd-Font-Ligaturized/*.otf" "$font_path" && rm -rf ./SFMono-Nerd-Font-Ligaturized
    # Install Victor Mono Nerd Font
    brew tap homebrew/linux-fonts && brew install homebrew/linux-fonts/font-victor-mono-nerd-font
  else
    echo_error "Unsupported operating system: $OSTYPE"
    return 1
  fi
}
