#!/bin/sh
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
export SSH_AUTH_SOCK=/tmp/agent.sock

function ssh-login() {
  eval $(ssh-agent -a $SSH_AUTH_SOCK)
  find ~/.ssh -type f | grep -v config | grep -v known_hosts | grep -v .pub | xargs ssh-add
}
