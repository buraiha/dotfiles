#!/bin/bash
# if exists setting file then overwritting.
# 2020/05/15
# Takashi Furuhashi <tf@yorozu-sys.net>

# OS research
OS=""
if [ "$(uname -s)" == 'Darwin' ]; then
	OS='Mac'
elif [ "$(uname -s)" == 'Linux' ]; then
	OS='Linux'
elif [ "$(uname -s)" == 'MINGW32_NT' ]; then                                                                                           
	OS='Cygwin'
else
	echo "Your platform ($(uname -a)) is not supported."
	exit 1
fi
echo -n "install for dotfiles..."

cd $HOME/dotfiles
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig

echo "done."
