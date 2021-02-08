#!/bin/bash

 defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.dotfiles/iterm"
 defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
