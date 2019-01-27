#!/bin/sh

brew install pip
pip install pyp
cat $HOME/.dotfiles/python/pip.txt | pyp "' '.join(pp)" | xargs sudo pip install