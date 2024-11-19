#!/bin/bash

[ "$(uname -s)" != "Darwin" ] && exit 0

brew cask install visual-studio-code
