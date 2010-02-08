#!/bin/bash

# Custom shell prompt (indicates the current git branch).

function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function myprompt {
	local        BLUE="\[\033[0;34m\]"
	local       GREEN="\[\033[0;32m\]"
	local LIGHT_GREEN="\[\033[1;32m\]"
	local       WHITE="\[\033[1;37m\]"
	local  LIGHT_GRAY="\[\033[0;37m\]"

	PS1="$BLUE($GREEN\u@\h:\w$LIGHT_GRAY\$(parse_git_branch)$BLUE) $WHITE\n$ "
	PS2='> '
	PS4='+ '
}
myprompt

# Tab completion performs cycling behavior.
# Unfortunately this gets rid of the completion list display.
#bind '"\t":menu-complete'

# Ensure our custom inputrc settings are used.
export INPUTRC=~/.inputrc

