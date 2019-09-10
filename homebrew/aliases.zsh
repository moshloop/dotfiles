#!/bin/sh
brew() {
  case "$1" in
    cleanup)
      command brew cleanup
      brew cask cleanup
      ;;
    bump)
      brew update
      brew upgrade --all
      brew cleanup
      ;;
    *)
      command brew "$@"
      ;;
  esac
}

export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_NO_ANALYTICS=true
