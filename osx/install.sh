#!/bin/bash
[ "$(uname -s)" != "Darwin" ] && exit 0

rm -rf $HOME/Library/Scripts
cp $HOME/.dotfiles/osx/Scripts/* /Library/Scripts/
for app in $(cat ~/.dotfiles/osx/brew.txt); do
	brew install $app
done
for app in $(cat ~/.dotfiles/osx/cask.txt); do
	brew cask install $app
done
$HOME/.dotfiles/osx/set-defaults.sh
