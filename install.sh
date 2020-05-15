#!/bin/sh

echo -n "install for dotfiles..."

cd $HOME/dotfiles
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig

echo "done."
