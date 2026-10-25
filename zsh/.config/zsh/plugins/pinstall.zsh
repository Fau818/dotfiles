# ╔══════════════════════════════════════════════════════════╗
# ║                         Pinstall                         ║
# ╚══════════════════════════════════════════════════════════╝

# The installers are one zsh script in this config; `starter.sh` runs the same one on a new machine.
PINSTALL_SCRIPT="$ZSCRIPTDIR/installers.zsh"


# List the installers that run on this platform, one `<name>\t<description>` per line.
function __pinstall_list() { zsh "$PINSTALL_SCRIPT" --list }

# Run the named installers in order; with no names, list the ones available here.
function pinstall() {
  local line
  if (( $# == 0 )); then
    echo 'Usage: pinstall <installer> ...'
    for line in ${(f)"$(__pinstall_list)"}; do printf '  %-12s %s\n' "${line%%$'\t'*}" "${line#*$'\t'}"; done
    return 0
  fi
  zsh "$PINSTALL_SCRIPT" "$@"
}
