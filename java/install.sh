#!/bin/sh
[ "$(uname -s)" != "Darwin" ] && exit 0

brew cask install java
# install some java stuff
brew install maven ant gradle groovy
