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


ado-pr() {
  git stash && git pull --rebase origin main   && git stash pop
  git push origin main:pr/$1
  id=$(az repos pr create --auto-complete true -s pr/$1 -t main -r Infrastructure | jq -r .codeReviewId)
  az repos pr  set-vote --id $id --vote approve
}

ado-pr-fast() {
  git stash && git pull --rebase origin main   && git stash pop
  git push origin main:pr/$1
  id=$(az repos pr create  -s pr/$1 -t main -r Infrastructure | jq -r .codeReviewId)
  az repos pr  update --id $id --bypass-policy --bypass-policy-reason "fast-pass" --delete-source-branch --status completed
}

gtp() {
  git tag $1
  git push origin $1
}

gsf() {
  find . -maxdepth 2 -type d -name .git -print -execdir git status \;
}

gpt() {
  git push origin $( git tag | tail -n 1 )
  git push origin master
}

git-active-branch() {
  git branch | grep '*' | sed 's/*//' | sed 's/ //'
}

git-cp-into-main() {
   BRANCH=$(git-active-branch)
   git stash
   git checkout main
   git pull --rebase origin main
   git cherry-pick $1
   git push origin
   git checkout $BRANCH
   git stash pop
}


push-tag() {
  git pull --rebase origin main --autostash
  tag=$(git-new-minor)
  echo "Pushing $tag"
  git tag $tag
  git push origin $tag
}

git-new-minor() {
  CURTAG=$(git describe --abbrev=0 --tags)
  CURTAG="${CURTAG/v/}"
  BASE_LIST=(`echo $CURTAG | tr '.' ' '`)
  MAJ=${BASE_LIST[1]}
  MIN=${BASE_LIST[2]}
  BUG=${BASE_LIST[3]}
  ((BUG+=1))
  echo "v$MAJ.$MIN.$BUG"
}

gup() {
    set -e
    BRANCH=$(git-active-branch)
    git stash

    git fetch origin
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
