#!/bin/sh

pip install pgcli mycli ansible ansible-cmdb

[ "$(uname -s)" != "Darwin" ] && exit 0

brew install s3cmd packer ngrok awscli
