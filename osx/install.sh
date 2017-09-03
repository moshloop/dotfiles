#!/bin/sh
[ "$(uname -s)" != "Darwin" ] && exit 0

brew install pip
pip install pyp
cat brew.txt | pyp "' '.join(pp)" | xargs brew install