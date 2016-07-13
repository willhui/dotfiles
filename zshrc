# -----------------------------------------------------------
# General
# -----------------------------------------------------------

# OS detection.
platform=`uname`

zstyle :compinstall filename '~/.zshrc'

# Tell zsh about our local function directory.
fpath=(~/.zsh $fpath)

# ZSH plugin location
ZSH_PLUGIN_DIR=~/dev/external/

# Beeps are annoying.
setopt no_beep

# Just type a directory name to cd into it.
setopt autocd

# Keep background processes running at full speed.
setopt nobgnice


# -----------------------------------------------------------
# Prompt
# -----------------------------------------------------------

autoload -U promptinit
promptinit

source $ZSH_PLUGIN_DIR/zsh-git-prompt/zshrc.sh
PROMPT='%F{darkgrey}%B[%b%F{cyan}%n%F{darkgrey}%B@%b%F{red}%m%F{darkgrey}%B:%b%F{green}%d%F{darkgrey}%B] $(git_super_status)
%B%F{white}$ '


# -----------------------------------------------------------
# Key bindings
# -----------------------------------------------------------

bindkey -e

# Ctrl+left to move left one word.
bindkey '[1;5D' backward-word

# Ctrl+right to move right one word.
bindkey '[1;5C' forward-word

# Alt+enter to allow multiline input.
bindkey '' self-insert

# Prevent word backspace from deleting an entire path.
export WORDCHARS='*?[]~=&;!#$%&(){}<>'


# -----------------------------------------------------------
# History
# -----------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Prevent simultaneous zsh sessions from clobbering each other's
# history on exit.
setopt append_history

# Ignore duplicate commands in history.
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
# Case-insensitive (all), partial-word and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Expand partial paths.
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

setopt extendedglob
setopt no_case_glob

# Allow tab completion in the middle of a word.
setopt complete_in_word

# Tab completion moves to end of word.
setopt always_to_end

# Git.
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

# Vim is nice for quick edits.
export EDITOR=vim
export VISUAL=vim

# Less is more.
export PAGER=less

# Virtualenvwrapper (for python environments).
export WORKON_HOME=$HOME/virtualenvs/
export PROJECT_HOME=$HOME/dev
VEW_BIN=/usr/local/bin/virtualenvwrapper.sh
if [[ -e $VEW_BIN ]]; then
	source $VEW_BIN
fi

if [[ "$platform" == 'Darwin' ]]; then
	# Ant 1.7.1
	export ANT_HOME=~/apache-ant-1.7.1
	export JAVA_HOME=$(/usr/libexec/java_home)

	# Subversion 1.6.5
	export PATH=/opt/subversion/bin:$PATH

	# Google Go
	export GOROOT=/usr/local/go

elif [[ "$platform" == 'Linux' ]]; then
	export JAVA_HOME=/usr/lib/jvm/java-6-sun/

	# default cscope db
	export CSCOPE_DB=~/dev/blade/cscope.out

	# osdev
	export BLADE="/home/will/projects/osdev/blade"

	# Google Go
	export GOROOT=/usr/lib/go
fi

# TMP and TEMP are defined in the Windows environment. Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences for Cygwin.
if [[ "$OSTYPE" == 'cygwin' ]]; then
	unset TMP
	unset TEMP
fi

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

# Recursive grep.
alias gr="grep -rnIi --color=auto"

# Find file.
alias ff="find . -iname"

# Disk usage reporting with human-readable units.
alias df="df -h"
alias du="du -h"

# Warn on mixed tab/space indentation.
alias python="python -t"

# To use colorgcc, create a symlink for cc, gcc, g++ to colorgcc
# somewhere in your PATH before the actual aforementioned binaries.
if [[ "$platform" == 'Linux' ]]; then
	alias gcc="colorgcc --color"
fi

# Color-coded 'ls' output.
if [[ "$platform" == 'Darwin' ]]; then
	alias ls="ls -G"
else
	alias ls="ls --color"
fi

# Color-coded 'grep' output.
alias grep="grep --color"

# Cscope.
alias set-cscope-db="source set-cscope-db"

# Perforce Jam.
alias jam="jam -q"

# Android SDK.
export ANDROID_HOME=~/adt-bundle-linux-x86-20140321/sdk/
export PATH=$ANDROID_HOME/tools/:$ANDROID_HOME/platform-tools/:$PATH

# Eclim.
export ECLIPSE_HOME=~/adt-bundle-linux-x86-20140321/eclipse
alias eclimd=$ECLIPSE_HOME/eclimd

# ~/bin must always come first in $PATH
export PATH=~/bin:$PATH

ITERM2_SHELL_INTEG=~/.iterm2_shell_integration.`basename $SHELL`
if [[ -e $ITERM2_SHELL_INTEG ]]; then
	source $ITERM2_SHELL_INTEG
fi

# Pick up any extra user customization, if available.
USER_CONFIG=~/.zshrc.user
if [[ -e $USER_CONFIG ]]; then
	source $USER_CONFIG
fi

# ===================================================================
# Enable shell syntax highlighting. This line *must* remain
# at the end of the file.
# ===================================================================
source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
