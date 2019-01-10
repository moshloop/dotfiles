#!/bin/zsh
__reload_dotfiles() {
  PATH="$(command -p getconf PATH):/usr/local/bin"
  . ~/.zshrc
  cd .
}


alias reload!='__reload_dotfiles'
alias rscp='rsync -v -e "ssh" --rsync-path="sudo rsync"  -arvuz --exclude ".DS_Store" --exclude ".git" '
alias s3='s3cmd  --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET'
alias aliases.zsh="subl -w ~/.dotfiles/zsh/aliases.zsh && source ~/.dotfiles/zsh/aliases.zsh"

function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

if test "$(which exa)"; then
    e "Found exa at: " "$(which exa)";
    alias lsl="exa --group-directories-first"
fi

e() {
	echo -e "\e[96m$@[1,-1]"
}

aq() {
    awk '{print $1}' | grep -v NAME
}