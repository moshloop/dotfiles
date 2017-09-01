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



alias ls="exa --group-directories-first"

e() {
	echo -e "\e[96m$@[1,-1]"
}
