#!/bin/sh
__reload_dotfiles() {
  PATH="$(command -p getconf PATH):/usr/local/bin"
  . ~/.zshrc
  cd .
}
alias reload!='__reload_dotfiles'

alias jup="git fetch && git rebase origin master && jekyll serve"
alias groovy='sudo java -cp "/workspace/PT/libs/*:/workspace/PT/build/*.jar" groovy.lang.GroovyShell'
alias rscp='rsync -v -e "ssh" --rsync-path="sudo rsync"  -arvuz --exclude ".DS_Store" --exclude ".git" '
alias build='gulp --gulpfile $BUILD/Gulpfile.js --cwd ./'
alias slaves='python $OPS/vm/__init__.py --type'
alias s3='s3cmd  --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET'
alias grad="gradle jar && cp build/libs/egis-* $WORK_DIR/build"
alias mvn_down='java -jar ~/.dotfiles/bin/ivy.jar -retrieve "libs/[artifact]-[type]-[revision].[ext]" ' 