#!/bin/sh
alias gl='git pull --prune'
alias glg="git log --graph --decorate --oneline --abbrev-commit"
alias gp='git push origin HEAD'
alias gpa='git push origin --all'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gs='git status -sb'
alias gcb='git-copy-branch-name'
alias gup='git stash && git pull --rebase origin master && git stash pop'
alias xpath='xmlstarlet sel -t -v'

merge() {
	github-pullrequests-merge-helper git@github.com:egis/$1.git --pattern="Update\s.+\sto\sversion"
}

clean() {
	echo "Cleaning $1"
	cd /workspace/misc/$1
	cleanup-merges
}


new-repo() {
    team=158993
    http -v --auth moshe-immerman:$GH_TOKEN POST https://api.github.com/orgs/egis/repos name=$1 private=true team_id=$team auto_init=true
    circleci-follow $1
    open "https://www.codacy.com/wizard/projects?orgId=3047"
}

circleci-follow() {
  http --auth $CIRCLECI: --form POST https://circleci.com/api/v1.1/project/github/egis/$1/follow
}


cleanup-merges() {
	git fetch --all
	git branch -r | grep autoupdate | sed s%origin/%% | xargs -L 1 git push origin --delete 
}

git-fetch-all() {
    for remote in `git branch -r  | grep -v 'HEAD\|master' `; do git branch --track $remote; done
}

git-prune() {
    git branch -r --merged | grep origin | grep -v master | grep -v HEAD | cut -d "/" -f2 | xargs -n 1 git push --delete origin
}

gpr() {
  gp && open-pr "$*"
}

gi() {
  curl -s "https://www.gitignore.io/api/$*";
}
