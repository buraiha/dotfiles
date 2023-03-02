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

# install .gitconfig
if [ -f $HOME/.gitconfig ]; then
	rm -f $HOME/.gitconfig
fi
ln -s ./.gitconfig $HOME/.gitconfig

# mac setting function 
function setting_mac () {
	cd "$1";

	# settings.json
	if [ -f settings.json ]; then
		rm -f settings.json
	fi
	ln -s ./vscode/settings.json .

	# keybindings.json
	if [ -f keybindings.json ]; then
		rm -f keybindings.json
	fi
	ln -s ./vscode/keybindings.json .

	# snippets directory
	if [ -d snippets ]; then
		rm -rf snippets
	fi
	ln -s ./vscode/snippets .
}

#install Visual Studio Code settings
if [ $OS == 'Mac' ]; then
	TARGET_PATH1="$HOME/Library/Application Support/Code/User/"
	if [ -d "$TARGET_PATH1" ]; then
		echo "setting 1"
		setting_mac "$TARGET_PATH1"
	fi

	TARGET_PATH2="$HOME/Library/Application Support/Code - Insiders/User/"
	if [ -d "$TARGET_PATH2" ]; then
		echo "setting 2"
		setting_mac "$TARGET_PATH2"
	fi

fi

cd $HOME

echo "done."
