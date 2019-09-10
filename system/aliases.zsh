#!/bin/sh
# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
# shellcheck disable=SC2039

alias duf="du -sh * | sort -hr"

if [ -z "$(command -v pbcopy)" ]; then
  if [ -n "$(command -v xclip)" ]; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
  elif [ -n "$(command -v xsel)" ]; then
    alias pbcopy="xsel --clipboard --input"
    alias pbpaste="xsel --clipboard --output"
  fi
fi

if [ "$(uname -s)" != "Darwin" ]; then
  if [ -e /usr/bin/xdg-open ]; then
    alias open="xdg-open"
  fi
fi

# greps non ascii chars
nonascii() {
  LANG=C grep --color=always '[^ -~]\+';
}

alias wget="wget --no-check-certificate"
alias pgo="nocorrect pgo"
alias helm="nocorrect helm"
