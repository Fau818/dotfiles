# ════════════════════════════════════════════════════════════
# ═══════════════════════ Google Cloud ═══════════════════════
# ════════════════════════════════════════════════════════════

(( $+commands[gcloud] )) || return


# ════════════════════════ Instances ═════════════════════════

# Run `gcloud compute instances <action> <name>` without passing --zone.
#
#   gvm <action> <name> [args...]  # e.g. gvm start ashen-witch
function gvm() {
  if (( $# < 2 )); then echo_error 'Usage: gvm <action> <name> [args...]' && return 1; fi
  local action=$1 name=$2; shift 2
  # Look up the zone on every call: GPU VMs land in whichever zone had capacity.
  # NOTE: An anchored regex, as in `~/.ssh/config`: gcloud is moving `name=` to word matching, so `ashen-witch` would also hit `ashen-witch-away`.
  local zones=(${(f)"$(gcloud compute instances list --filter="name~^$name\$" --format='value(zone.basename())')"})
  if (( ${#zones} == 0 )); then echo_error "No instance named $(echo_hl "$name")." && return 1; fi
  if (( ${#zones} > 1 )); then echo_error "$(echo_hl "$name") exists in several zones ($(echo_hl "${zones[*]}")); use $(echo_hl 'gcloud') with $(echo_hl '--zone')." && return 1; fi
  gcloud compute instances "$action" "$name" --zone="${zones[1]}" "$@"
}


# ═══════════════════════ Completions ════════════════════════

# NOTE: A bash-style script without a `#compdef` header, so it is sourced after compinit rather than autoloaded from `$fpath`.
() { [[ -r "$1" ]] && source "$1" } "${commands[gcloud]:A:h:h}/completion.zsh.inc"

# Complete `gvm` the same way as `gcloud compute instances`.
function _gvm_complete() {
  # Rewrite the line as `gcloud compute instances ...` and hand it to gcloud's own completer, from its completion.zsh.inc.
  local prefix='gcloud compute instances'
  COMP_LINE="$prefix${COMP_LINE#gvm}"
  (( COMP_POINT += ${#prefix} - 3 ))  # 3 = length of "gvm"
  _python_argcomplete gcloud "$2" "$3"
}
(( $+functions[_python_argcomplete] )) && complete -o nospace -o default -F _gvm_complete gvm
