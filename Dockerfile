# caarlos0/dotfiles test container
FROM ubuntu:16.04
MAINTAINER Carlos Alexandro Becker <caarlos0@gmail.com>

RUN apt-get update && apt-get install -y software-properties-common wget zsh git curl python sudo

COPY . /root/.dotfiles

RUN cd /root/.dotfiles && \
  rm -f ./git/gitconfig.symlink && \
  sed \
    -e "s/AUTHORNAME/dotfiles-demo/g" \
    -e "s/AUTHOREMAIL/dotfiles-demo/g" \
    -e "s/GIT_CREDENTIAL_HELPER/cache/g" \
    ./git/gitconfig.symlink.example > ./git/gitconfig.symlink && \
  git remote rm origin && \
  ./script/bootstrap && \
  zsh -c "source ~/.zshrc" || true

ENTRYPOINT zsh
