#!/bin/bash

[ "$(uname -s)" != "Darwin" ] && exit 0


brew install iterm2
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
