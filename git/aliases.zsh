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

gup() {
    BRANCH=$(git branch | grep '*' | sed 's/*//' | sed 's/ //')
    git stash
    git pull --rebase origin $BRANCH
    git stash pop
}

merge() {
	github-pullrequests-merge-helper git@github.com:egis/$1.git --pattern="Update\s.+\sto\sversion"
}

clean() {
	echo "Cleaning $1"
	cd /workspace/misc/$1
	cleanup-merges
}


get-team-id() {
  response=$(http --print=b --pretty=none --auth $me:$GH_TOKEN GET https://api.github.com/orgs/$1/teams)
  response=$( echo $response | jq -r '. | map([.name, .id | @text]  | join("="))  | join("\n")' )
  echo $response | grep $2 | head -n 1 | cut -d= -f2
}

new-repo() {
  echo "Getting team id: $GH_ORG $2"
    team=$(get-team-id $GH_ORG $2)
    echo "team-id = $team"
    if [[ "$team" = "" ]]; then
      echo "Could not find team: $GH_ORG:$2"
      exit 1
    fi
    echo "Creating repo $1 owned by $GH_ORG:$2"
    http -v --auth ${GH_USER}:$GH_TOKEN POST https://api.github.com/orgs/$GH_ORG/repos name=$1 private=true team_id=$team auto_init=true
    circleci-follow $1
    open "https://www.codacy.com/wizard/projects?orgId=3047"
}

circleci-follow() {
  http --auth $CIRCLECI: --form POST https://circleci.com/api/v1.1/project/github/$GH_ORG/$1/follow
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

git-pr() {
   if [[ $(git branch | grep pr/"$1") ]]; then
      git branch -D pr/"$1"
  fi
  remote=origin
  if $(git remote -v | grep upstream); then
    remote=upstream
  fi
  git fetch $remote pull/"$1"/head:pr/"$1"
  git checkout pr/"$1"
}

commit() {
  git push origin master:$1
  ghpr -h $1 -t $1
}
