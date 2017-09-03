#!/bin/sh
[ "$(uname -s)" != "Darwin" ] && exit 0

 cat brew.txt | pyp "' '.join(pp)" | xargs brew install