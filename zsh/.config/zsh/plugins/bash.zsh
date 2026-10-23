# ════════════════════════════════════════════════════════════
# ═══════════════════════════ Bash ═══════════════════════════
# ════════════════════════════════════════════════════════════

# Where bash is the login shell, keep a block at the top of `~/.bashrc` that hands it over to zsh.

[[ ${SHELL:t} == bash && -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]] || return

() {
  local begin='# >>> zsh handoff >>>' end='# <<< zsh handoff <<<'
  local -a block=(
    "$begin (managed by the dotfiles)"
    '# `ssh host CMD` runs a bash that never reads the zsh config'
    'export PATH="$HOME/.local/bin:$PATH"'
    '# Login shells only: a `bash` typed later stays bash'
    'if [[ $- == *i* ]] && shopt -q login_shell && [ -t 1 ] && command -v zsh > /dev/null; then exec zsh -l; fi'
    "$end"
  )

  # Everything except earlier blocks and the blank line after each
  local -a old=("${(@f)$(<"$HOME/.bashrc")}") rest=()
  local line state=keep
  for line in "${old[@]}"; do
    if [[ $state == after ]]; then state=keep; [[ -z $line ]] && continue; fi
    case $state in
      keep)  [[ $line == "$begin"* ]] && state=block && continue ;;
      block) [[ $line == "$end"* ]] && state=after; continue ;;
    esac
    rest+=("$line")
  done
  # A begin marker without its end: leave the file alone instead of dropping everything after it
  if [[ $state == block ]]; then print -u2 "zsh: '$end' is missing from ~/.bashrc; not updating it" && return; fi

  local new="${(F)block}"
  (( ${#rest} )) && new+=$'\n\n'"${(F)rest}"
  [[ $new == "${(F)old}" ]] && return  # Up to date: don't touch the file

  # Write a copy, then swap it in, so an interrupted write can't truncate `~/.bashrc`.
  local tmp="$HOME/.bashrc.tmp.$$"
  cp -p "$HOME/.bashrc" "$tmp" && print -r -- "$new" > "$tmp" && mv "$tmp" "$HOME/.bashrc" || rm -f "$tmp"
}
