#!/bin/bash

cd $HOME/.dotfiles
git ls-tree --name-only -r HEAD | grep install.sh | while read -r installer; do
  echo "${installer}..."
  $installer
done