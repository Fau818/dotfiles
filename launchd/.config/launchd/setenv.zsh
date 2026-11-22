#!/bin/zsh
# Hands the variables ~/.zshenv sets to launchd, so apps opened from the Dock or Spotlight, and whatever they
# start, use the same paths as a shell; com.phoenix.env runs this at login and whenever .zshenv changes.
#   1. Restart with an empty environment, so all that is left comes from ~/.zshenv.
#   2. `launchctl setenv` each exported variable, except secrets and those only a shell should have.
#   3. `launchctl unsetenv` the ones set last time that .zshenv no longer has, and log what changed.

[[ -v FAU_SETENV_CLEAN ]] || exec /usr/bin/env -i HOME="$HOME" USER="$USER" FAU_SETENV_CLEAN=1 /bin/zsh "$0"

# NOTE: LANG and LC_* would override every app's own language; ZDOTDIR would make new zshs skip ~/.zshenv.
local -a skip=(
  FAU_SETENV_CLEAN HOME USER LOGNAME PWD OLDPWD SHLVL _ PATH SHELL TERM LANG 'LC_*' HISTFILE 'Z*'
  '*TOKEN*' '*KEY*' '*SECRET*' '*PASSWORD*'
)
local state="$XDG_STATE_HOME/launchd/setenv"
mkdir -p "${state:h}"

local -a names old gone
local name pattern
for name in ${(ok)parameters[(R)*export*]}; do
  for pattern in $skip; do [[ "$name" == ${~pattern} ]] && continue 2; done
  launchctl setenv "$name" "${(P)name}"
  names+=("$name")
done

[[ -r "$state" ]] && old=(${(f)"$(<"$state")"})
gone=(${old:|names})
for name in $gone; do launchctl unsetenv "$name"; done
print -l -- $names > "$state"

print -- "$(date '+%F %T') set ${#names}: $names"
(( $#gone )) && print -- "  unset: $gone"
