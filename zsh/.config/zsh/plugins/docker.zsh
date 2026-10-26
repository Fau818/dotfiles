# ╔══════════════════════════════════════════════════════════╗
# ║                          Docker                          ║
# ╚══════════════════════════════════════════════════════════╝

(( $+commands[docker] )) || return

# Allow option-stacking for docker completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Open a zsh login shell inside a running container.
function dzsh() {
  [[ -z "$1" ]] && echo 'Usage: dzsh <container-name-or-id>' && return 1
  docker exec --env "TERM=$TERM" -it "$1" zsh -l
}
