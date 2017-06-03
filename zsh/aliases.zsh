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


port_forward() {
	echo "forward $1 to $2:$3"
	echo "
		rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port $1 ->  $2 port $3
	" | sudo pfctl -ef -
}

switch_local() {
	export PT_API=http://127.0.0.1:8080
	export PT_USER=admin
	export PT_PASS=p
}



e() {
	echo -e "\e[96m$@[1,-1]"
}
