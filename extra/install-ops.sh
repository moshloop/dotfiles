#!/bin/sh

pip install pgcli mycli ansible ansible-cmdb cloudflare-cli esx-cli  ansible awscli s3transfer s4cmd

[ "$(uname -s)" != "Darwin" ] && exit 0

brew install s3cmd packer ngrok