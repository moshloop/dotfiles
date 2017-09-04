#!/bin/bash
[ "$(uname -s)" != "Darwin" ] && exit 0

# sudo easy_install pip
# sudo pip install pyp
pkgs=`brew list -1`


for pkg in `cat brew.txt`; do
    if [[ $pkgs == *"$pkg"* ]]; then
        echo $pkg already installed
    else
        echo install $pkg
        brew install $pkg
    fi
done