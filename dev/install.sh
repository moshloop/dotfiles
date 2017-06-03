#!/bin/sh


npm install -g wdio tldr npm karma-cli babel-cli esdoc eslint grunt gulp how2 rollup

[ "$(uname -s)" != "Darwin" ] && exit 0

brew install lnav node  sqlite