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
alias sudo='sudo '
alias mv='mv -v'
alias ctaz='tar -zcvf' xtaz='tar -zxvf'
alias gcmm='git commit -m' gcmmd='gcmm "$(DATE)"'

# Kitty
[ "$TERM" = 'xterm-kitty' ] && alias kssh='kitty +kitten ssh'
# Rsync
command -v rsync &> /dev/null && alias frsync='rsync -razvhP'
# Mysql
command -v mysql &> /dev/null && alias mysqlStart='mysql.server start' mysqlStop='mysql.server stop'
# Stow
if (command -v stow && ! command -v __stow) &> /dev/null; then
  function __stow() {
    [[ -z "$1" ]] && echo_red "ERROE: Empty Package Name!" && return 0
    local name="$1"
    local dotfile_dir=$([[ -d "$DOTFILE_PATH/private/$name" ]] && echo "$DOTFILE_PATH/private" || echo "$DOTFILE_PATH")

    stow --dir="$dotfile_dir" --target="$HOME" --ignore='.DS_Store' "$name"
  }
  alias stow=__stow
fi


# -----------------------------------
# -------- Plugins
# -----------------------------------
source "$ZPLUGINDIR/homebrew.zsh"

source "$ZPLUGINDIR/neovim.zsh"
source "$ZPLUGINDIR/python.zsh"
source "$ZPLUGINDIR/gadget.zsh"

source "$ZPLUGINDIR/zinit.zsh"
