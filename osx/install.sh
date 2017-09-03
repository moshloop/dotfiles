#!/bin/sh
[ "$(uname -s)" != "Darwin" ] && exit 0

sudo easy_install pip
sudo pip install pyp
cat brew.txt | pyp "' '.join(pp)" | xargs brew install