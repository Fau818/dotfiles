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
