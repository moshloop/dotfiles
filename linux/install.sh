#!/bin/sh
["$(uname -s)" != "Linux" ] && exit 0

sudo apt-get install -y libhttp-parser2.1 sudo unzip
wget https://github.com/ogham/exa/releases/download/v0.7.0/exa-linux-x86_64-0.7.0.zip
sudo unzip -p exa-linux-x86_64-0.7.0.zip /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa