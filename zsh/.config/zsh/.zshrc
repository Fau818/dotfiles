# =============================================
# ======== Powerlevel10k Instant Prompt
# =============================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Source p10k configuration
[[ ! -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] || source "${ZDOTDIR:-$HOME}/.p10k.zsh"



# =============================================
# ======== Fau ZSH Preferences
# =============================================
setopt interactive_comments
fpath=($ZDOTDIR/completions $fpath)
[[ -d "$HOME/.docker/completions/" ]] && fpath=($HOME/.docker/completions $fpath)  # Docker completion
# -----------------------------------
# -------- Basic Aliases
# -----------------------------------
alias sudo='sudo -E '
alias vi='vi -i NONE'
alias mv='mv -v'
alias wget="wget --hsts-file=$XDG_CACHE_HOME/.wget-hsts"
alias ctaz='tar -zcvf' xtaz='tar -zxvf'
alias gcmm='git commit -m' gcmmd='gcmm "$(date)"'


# -----------------------------------
# -------- Scripts
# -----------------------------------
alias ghr2cdn="$ZSCRIPTDIR/ghr2cdn.sh"
alias cdn2ghr="$ZSCRIPTDIR/cdn2ghr.sh"


# -----------------------------------
# -------- Plugins
# -----------------------------------
source "$ZPLUGINDIR/colorful_print.zsh"
source "$ZPLUGINDIR/vpn.zsh"

source "$ZPLUGINDIR/homebrew.zsh"
source "$ZPLUGINDIR/neovim.zsh"

source "$ZPLUGINDIR/utils.zsh"
source "$ZPLUGINDIR/python.zsh"
source "$ZPLUGINDIR/installer.zsh"

source "$ZPLUGINDIR/zinit.zsh"


# Docker
if command -v docker &> /dev/null; then
  dzsh() {
    [[ -z "$1" ]] && echo "Usage: dzsh <container-name-or-id>" && return 1
    docker exec --env TERM=$TERM -it "$1" zsh -l
  }
fi

# Eza (NOTE: Make sure setup after zinit)
command -v eza &> /dev/null && alias ls='eza --icons --time-style=iso'

# Ripgrep
command -v rg &> /dev/null && alias rg="rg --ignore-file '$XDG_CONFIG_HOME/git/ignore'"

# Npm
command -v npm &> /dev/null && source <(npm completion)


# -----------------------------------
# -------- Goto Home if Login Shell
# -----------------------------------
[[ "$(uname)" == 'Linux' && "$SHLVL" -eq 1 ]] && cd ~ || true
