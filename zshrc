# -----------------------------------------------------------
# General
# -----------------------------------------------------------

# OS detection
export OS=`uname`

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

export PATH=~/bin:$PATH
export EDITOR=vim
export VISUAL=vim
export PAGER=less

if [[ $OS == "Linux" ]] then
	export JAVA_HOME=/usr/lib/jvm/java-6-sun/

	# default cscope db
	export CSCOPE_DB=~/dev/blade/cscope.out

	# osdev
	export BLADE="/home/will/projects/osdev/blade"
fi

if [[ $OS == "Darwin" ]] then
	# MacPorts
	export MACPORTS_PREFIX=/opt/local
	export PATH=$MACPORTS_PREFIX/bin:$MACPORTS_PREFIX/sbin:$PATH
	export MANPATH=$MACPORTS_PREFIX/share/man:/Developer/usr/share/man:$MANPATH
fi

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------
# To use colorgcc, create a symlink for cc, gcc, g++ to
# colorgcc somewhere in your PATH before the actual
# aforementioned binaries.

alias python="python -t"

if [[ $OS == "Linux" ]] then
	alias ls="ls --color"
elif [[ $OS == "Darwin" ]] then
	alias ls="ls -G"
fi

alias grep="grep --color"
alias set-cscope-db="source set-cscope-db"
alias jam="jam -q"
alias start-git-daemon="sudo -u git git-daemon --base-path=/home/git/repositories/ --export-all"

