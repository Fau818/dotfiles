# =============================================
# ======== Python
# =============================================
# -----------------------------------
# -------- Aliases
# -----------------------------------
alias python=python3 pip=pip3

alias pipUpgrade="pip3 list -o | cut -d ' ' -f 1 | tail -n +3 | xargs pip3 install -U"
alias pipUpgradeFautools='pip3 install -U Fau-tools -i https://pypi.org/simple'

alias pipia='pip3 install -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com'


# -----------------------------------
# -------- Pip Source
# -----------------------------------
# Acquire pip config file path utility
function ___pip_get_config_file_path() {
  # Make sure the config file exists
  local pip_conf_path="$XDG_CONFIG_HOME/pip"
  local pip_conf_file="$pip_conf_path/pip.conf"
  [ ! -e "$pip_conf_path" ] && mkdir -p "$pip_conf_path" && touch "$pip_conf_file"

  echo "$pip_conf_file"
}

# Official Source
function __pip_set_official_source() {
  local pip_conf_file=$(___pip_get_config_file_path)
  echo '# Official Source' > "$pip_conf_file"
}

# Tsinghua Source
function __pip_set_tsinghua_source() {
  local pip_conf_file=$(___pip_get_config_file_path)

  echo '[global]' > "$pip_conf_file" && \
  echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> "$pip_conf_file" && \
  echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> "$pip_conf_file"
}

# Aliyun Source
function __pip_set_aliyun_source() {
  local pip_conf_file=$(___pip_get_config_file_path)

  echo '[global]' > "$pip_conf_file" && \
  echo 'index-url = http://mirrors.aliyun.com/pypi/simple' >> "$pip_conf_file" && \
  echo 'trusted-host = mirrors.aliyun.com' >> "$pip_conf_file"
}



# =============================================
# ======== Conda
# =============================================
# -----------------------------------
# -------- Initialization
# -----------------------------------
if [ "$(uname)" = 'Darwin' ] && [ -v HOMEBREW_PREFIX ];            then export CONDA_ROOT="$HOMEBREW_PREFIX/Caskroom/miniconda/base"
elif [ "$(uname)" = 'Linux' ] && [ -d "$HOME/miniconda3" ];        then export CONDA_ROOT="$HOME/miniconda3"
elif [ "$(uname)" = 'Linux' ] && [ -d "$HOME/.local/miniconda3" ]; then export CONDA_ROOT="$HOME/.local/miniconda3"
elif [ "$(uname)" = 'Linux' ] && [ -d "/usr/local/miniconda3" ];   then export CONDA_ROOT="/usr/local/miniconda3"
fi

[ -v CONDA_ROOT ] && [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ] && source "$CONDA_ROOT/etc/profile.d/conda.sh"


# -----------------------------------
# -------- Aliases
# -----------------------------------
command -v conda &> /dev/null && alias dl='conda activate dl'
