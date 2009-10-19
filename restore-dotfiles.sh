#!/bin/sh

CWD=`pwd`

ln -snf $CWD/vim ~/.vim
ln -snf $CWD/vimrc ~/.vimrc
ln -snf $CWD/emacs ~/.emacs
ln -snf $CWD/emacs.d ~/.emacs.d
ln -snf $CWD/gitconfig ~/.gitconfig
ln -snf $CWD/zshrc ~/.zshrc

mkdir -p ~/.vim/swap
mkdir -p ~/.vim/view
