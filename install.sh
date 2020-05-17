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

DORFILESDIR="$HOME/dotfiles"

echo -n "install for dotfiles..."

cd $HOME/dotfiles

# install .gitconfig
if [ -f $HOME/.gitconfig ]
then
	rm -f $HOME/.gitconfig
fi
ln -s $DORFILESDIR/git/.gitconfig $HOME/.gitconfig

#install Visual Studio Code settings
if [ $OS == 'Mac' ]
then
	cd $HOME/Library/"Application Support"/Code/User/

	# settings.json
	if [ -f settings.json ]
	then
		rm -f settings.json
	fi
	ln -s $DORFILESDIR/vscode/settings.json .

	# keybindings.json
	if [ -f keybindings.json ]
	then
		rm -f keybindings.json
	fi
	ln -s $DORFILESDIR/vscode/keybindings.json .

	# snippets directory
	if [ -d snippets ]
	then
		rm -rf snippets
	fi
	ln -s $DORFILESDIR/vscode/snippets .

fi

cd $HOME

echo "done."
