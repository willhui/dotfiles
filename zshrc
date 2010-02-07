# -----------------------------------------------------------
# General
# -----------------------------------------------------------

# operating system detection
platform=`uname`

zstyle :compinstall filename '~/.zshrc'

# tell zsh about our local function directory
fpath=(~/.zsh $fpath)

# beeps are annoying
setopt no_beep

# just type a directory name to cd into it
setopt autocd

# keep background processes running at full speed
setopt nobgnice


# -----------------------------------------------------------
# Prompt
# -----------------------------------------------------------

autoload -U promptinit
promptinit

prompt adam2


# -----------------------------------------------------------
# Key bindings
# -----------------------------------------------------------

bindkey -e

# ctrl+left to move left one word
bindkey '[1;5D' backward-word

# ctrl+right to move right one word
bindkey '[1;5C' forward-word

# alt+enter to allow multiline input
bindkey '' self-insert

# prevent word backspace from deleting an entire path
export WORDCHARS='*?[]~=&;!#$%&(){}<>'

# ctrl+backspace to delete previous word
# (but this won't work in the gnome terminal, see
# http://bugzilla.gnome.org/show_bug.cgi?id=420039)
#bindkey '^H' backward-delete-word


# -----------------------------------------------------------
# History
# -----------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# prevent simultaneous zsh sessions from clobbering
# each other's history on exit
setopt append_history

# ignore duplicate commands in history
setopt hist_ignore_all_dups


# -----------------------------------------------------------
# Completion
# -----------------------------------------------------------

autoload -U zutil
autoload -U compinit
autoload -U complist
compinit

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' menu select=2
# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

setopt extendedglob
setopt no_case_glob

# allow tab completion in the middle of a word
setopt complete_in_word

# tab completion moves to end of word
setopt always_to_end

# git
zstyle ':completion::*:git:*' list_allcmds true
zstyle ':completion::*:git:*' list_aliases true

# -----------------------------------------------------------
# Environment variables
# -----------------------------------------------------------

# /usr/local contains administrator-installed software (not
# managed automatically by the underlying system). ~/bin
# contains user software (not installed at a system-wide level).
# This creates a chain of overridable binaries: system tools,
# admin-installed tools, and lastly user-installed tools.
# We prepend ~/bin at the bottom of this file to ensure that
# it is always at the beginning of $PATH.
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# vim is nice for quick edits
export EDITOR=vim
export VISUAL=vim

# less is more
export PAGER=less

if [[ "$platform" == 'Darwin' ]]; then
	# MacPorts software. Fall back on this stuff when equivalent
	# software does not exist anywhere else in the system.
	export MACPORTS_PREFIX=/opt/local
	export PATH=$PATH:$MACPORTS_PREFIX/bin:$MACPORTS_PREFIX/sbin
	export MANPATH=$MANPATH:$MACPORTS_PREFIX/share/man:/Developer/usr/share/man

	# Ant 1.7.1
	export ANT_HOME=~/apache-ant-1.7.1
	export JAVA_HOME=$(/usr/libexec/java_home)

	# Subversion 1.6.5
	export PATH=/opt/subversion/bin:$PATH

elif [[ "$platform" == 'Linux' ]]; then
	export JAVA_HOME=/usr/lib/jvm/java-6-sun/

	# default cscope db
	export CSCOPE_DB=~/dev/blade/cscope.out

	# osdev
	export BLADE="/home/will/projects/osdev/blade"
fi

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

# warn on mixed tab/space indentation
alias python="python -t"

# To use colorgcc, create a symlink for cc, gcc, g++ to
# colorgcc somewhere in your PATH before the actual
# aforementioned binaries.
if [[ "$platform" == 'Linux' ]]; then
	alias gcc="colorgcc --color"
fi

# color-coded ls output
if [[ "$platform" == 'Darwin' ]]; then
	alias ls="ls -G"
else
	alias ls="ls --color"
fi

# color-coded grep output
alias grep="grep --color"

alias set-cscope-db="source set-cscope-db"
alias jam="jam -q"

# start MacVim from the command line
if [[ "$platform" == 'Darwin' ]]; then
	function gvim {
		/Applications/MacVim/MacVim.app/Contents/MacOS/Vim -g $*;
	}
fi

# ~/bin must always come first in $PATH
export PATH=~/bin:$PATH
