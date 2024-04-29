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
# -----------------------------------
# -------- Basic Aliases
# -----------------------------------
alias sudo='sudo -E '
alias mv='mv -v'
alias ctaz='tar -zcvf' xtaz='tar -zxvf'
alias gcmm='git commit -m' gcmmd='gcmm "$(DATE)"'

# -----------------------------------
# -------- Scripts
# -----------------------------------
alias ghr2cdn="$ZSCRIPTDIR/ghr2cdn.sh"

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
# -------- Plugins
# -----------------------------------
source "$ZPLUGINDIR/vpn.zsh"

source "$ZPLUGINDIR/homebrew.zsh"
source "$ZPLUGINDIR/neovim.zsh"

source "$ZPLUGINDIR/utils.zsh"
source "$ZPLUGINDIR/python.zsh"
source "$ZPLUGINDIR/installer.zsh"

source "$ZPLUGINDIR/zinit.zsh"
