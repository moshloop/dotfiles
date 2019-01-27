#!/bin/sh

pip install pyp
cat $HOME/.dotfiles/python/pip.txt | pyp "' '.join(pp)" | xargs sudo pip install