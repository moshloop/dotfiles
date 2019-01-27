#!/bin/bash
[ "$(uname -s)" != "Darwin" ] && exit 0

rm -rf $HOME/Library/Scripts
ln -s $HOME/.dotfiles/osx/Scripts $HOME/Library/Scripts
brew install $(cat ~/.dotfiles/osx/brew.txt)
brew cask install $(cat ~/.dotfiles/osx/cask.txt)
$HOME/.dotfiles/osx/set-defaults.sh