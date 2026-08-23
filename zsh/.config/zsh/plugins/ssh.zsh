# ════════════════════════════════════════════════════════════
# ═══════════════════════════ SSH ════════════════════════════
# ════════════════════════════════════════════════════════════

if command -v ssh &> /dev/null; then
  # Complete ssh targets from the `~/.ssh/config` aliases rather than from `known_hosts`, which zsh otherwise prefers.
  # Keep the scope narrow: `ssh-keygen` does want `known_hosts`, and a bare `:completion:*:hosts` would hit `ping` and friends too.
  function __ssh_config_hosts() {
    [[ -r "$HOME/.ssh/config" ]] || return
    awk 'tolower($1) == "host" { for (i = 2; i <= NF; i++) if ($i !~ /[*?]/) print $i }' "$HOME/.ssh/config"
  }

  zstyle -e ':completion:*:(ssh|scp|sftp|sshfs|ssh-copy-id|rsync):*:hosts' hosts 'reply=( ${(fu)"$(__ssh_config_hosts)"} )'
fi
