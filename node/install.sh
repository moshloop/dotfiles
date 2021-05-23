#!/bin/sh
[ "$(uname -s)" != "Darwin" ] && exit 0
brew install node
npm install -g npm-run.plugin.zsh npm install -g git-split-diffs
