#!/bin/sh

# cd into the directory containing this shell script.
# See http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in/246128#246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd $DIR

ZSH_PLUGIN_DIR=~/dev/external/
CWD=`pwd`

ln -snf $CWD/vim ~/.vim
ln -snf $CWD/vimrc ~/.vimrc
ln -snf $CWD/emacs ~/.emacs
ln -snf $CWD/emacs.d ~/.emacs.d
ln -snf $CWD/gitconfig ~/.gitconfig
ln -snf $CWD/gitignore ~/.gitignore
ln -snf $CWD/bash_profile ~/.bash_profile
ln -snf $CWD/bashrc ~/.bashrc
ln -snf $CWD/zshrc ~/.zshrc
ln -snf $CWD/inputrc ~/.inputrc

mkdir -p $ZSH_PLUGIN_DIR
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/view

clone_repo () {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "clone_repo: missing parameter(s)"
	fi

	if [ ! -d $2 ]; then
		git clone $1 $2
	fi
}

clone_repo https://github.com/olivierverdier/zsh-git-prompt.git $ZSH_PLUGIN_DIR/zsh-git-prompt
clone_repo https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGIN_DIR/zsh-syntax-highlighting
clone_repo https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall
