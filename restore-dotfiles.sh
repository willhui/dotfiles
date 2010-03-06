#!/bin/sh

CWD=`pwd`

ln -snf $CWD/vim ~/.vim
ln -snf $CWD/vimrc ~/.vimrc
ln -snf $CWD/emacs ~/.emacs
ln -snf $CWD/emacs.d ~/.emacs.d
ln -snf $CWD/gitconfig ~/.gitconfig
ln -snf $CWD/gitignore ~/.gitignore
ln -snf $CWD/zshrc ~/.zshrc
ln -snf $CWD/bashrc ~/.bashrc
ln -snf $CWD/inputrc ~/.inputrc

mkdir -p ~/.vim/swap
mkdir -p ~/.vim/view
