#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.
[ "$(uname -s)" != "Darwin" ] && exit 0

# Check for Homebrew
if test ! "$(which brew)"; then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# more formualae
brew tap phinze/homebrew-cask || true
brew tap caskroom/versions || true
brew install brew-cask

# usefull stuff
PACKAGES="htop-osx heroku-toolbelt fpp gnupg httpie packer pwgen curl fasd gradle  wget redis diffmerge unrar git-extras peco"

for pkg in $PACKAGES; do
    if brew list -1 | grep -q "^${pkg}\$"; then
        echo "Package '$pkg' is installed"
    else
        brew install $pkg
    fi
done

brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize 
#webpquicklook suspicious-package
