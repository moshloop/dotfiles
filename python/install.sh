#!/bin/sh

cat $ZSH/python/pip.txt | pyp "' '.join(pp)" | xargs sudo pip install