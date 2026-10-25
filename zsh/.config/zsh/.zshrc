# ╔══════════════════════════════════════════════════════════╗
# ║                        Zsh Config                        ║
# ╚══════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────┐
# │               Powerlevel10k Instant Prompt               │
# └──────────────────────────────────────────────────────────┘

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Source p10k configuration
[[ ! -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] || source "${ZDOTDIR:-$HOME}/.p10k.zsh"


# ┌──────────────────────────────────────────────────────────┐
# │                 Phoenix ZSH Preferences                  │
# └──────────────────────────────────────────────────────────┘

setopt interactive_comments
fpath=($ZDOTDIR/completions $ZCACHEDIR/completions $fpath)


# ═════════════════════════ Aliases ══════════════════════════

# ─── Basic ──────────────────────────────────────────────────
# alias sudo='sudo -E '
alias vi='vi -i NONE'
alias mv='mv -v'
alias wget="wget --hsts-file=$XDG_CACHE_HOME/.wget-hsts"
alias ctaz='tar -zcvf' xtaz='tar -zxvf'
alias gcmm='git commit -m' gcmmd='gcmm "$(date)"'


# ─── Tools ──────────────────────────────────────────────────
# ┄┄┄ Kitty
[[ "$TERM" == 'xterm-kitty' ]] && alias kssh='kitty +kitten ssh'
# ┄┄┄ Rsync
command -v rsync &> /dev/null && alias frsync='rsync -razvhP'
# ┄┄┄ Mysql
command -v mysql &> /dev/null && alias mysqlStart='mysql.server start' mysqlStop='mysql.server stop'
# ┄┄┄ Neovim
command -v nvim &> /dev/null && alias vim=nvim
# ┄┄┄ Thefuck
command -v thefuck &> /dev/null && eval "$(thefuck --alias)" && alias ff=fuck
# ┄┄┄ Yabai
command -v yabai &> /dev/null && alias yabai_sudo='echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 "${commands[yabai]}" | cut -d " " -f 1) ${commands[yabai]} --load-sa" | sudo tee /private/etc/sudoers.d/yabai > /dev/null'
# ┄┄┄ Ripgrep
command -v rg &> /dev/null && alias rg="rg --ignore-file '$XDG_CONFIG_HOME/git/ignore'"


# ═════════════════════════ Plugins ══════════════════════════

# ─── Core ───────────────────────────────────────────────────
source "$ZPLUGINDIR/colorful_print.zsh"
source "$ZPLUGINDIR/cache.zsh"
source "$ZPLUGINDIR/vpn.zsh"
source "$ZPLUGINDIR/bash.zsh"


# ─── Tools ──────────────────────────────────────────────────
source "$ZPLUGINDIR/homebrew.zsh"
source "$ZPLUGINDIR/ssh.zsh"
source "$ZPLUGINDIR/docker.zsh"
source "$ZPLUGINDIR/python.zsh"
source "$ZPLUGINDIR/utils.zsh"
source "$ZPLUGINDIR/pinstall.zsh"


# ─── Zinit ──────────────────────────────────────────────────
source "$ZPLUGINDIR/zinit.zsh"


# ─── After Zinit ────────────────────────────────────────────
# NOTE: For plugins whose completions need compinit, which runs in zinit.
source "$ZPLUGINDIR/gcloud.zsh"

# Eza (NOTE: After zinit, or OMZL::theme-and-appearance.zsh overrides ls.)
command -v eza &> /dev/null && alias ls='eza --icons --time-style=iso'


# ═══════════════════════ Completions ════════════════════════

# NOTE: Generated into `$ZCACHEDIR/completions` on first use and refreshed whenever the tool itself is upgraded.

# ┄┄┄ Python
cached_compdef ruff ruff generate-shell-completion zsh
cached_compdef uv uv generate-shell-completion zsh

# ┄┄┄ Rust
cached_compdef cargo rustup completions zsh cargo
cached_compdef rustup rustup completions zsh rustup
