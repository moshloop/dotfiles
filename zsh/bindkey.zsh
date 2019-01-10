
bindkey -d
zle -N newtab
bindkey "^K"      kill-whole-line                      # ctrl-k
bindkey "^R"      history-incremental-search-backward  # ctrl-r
bindkey "^A"      beginning-of-line                    # ctrl-a
bindkey "^E"      end-of-line                          # ctrl-e
bindkey "[B"      history-search-forward               # down arrow
bindkey "[A"      history-search-backward              # up arrow
bindkey "^D"      delete-char                          # ctrl-d
bindkey "^[[3~"   delete-char
bindkey '^?'      backward-delete-char
bindkey "^F"      forward-word                         # ctrl-f
bindkey "^B"      backward-word                       # ctrl-b
bindkey -e   # Default to standard emacs bindings, regardless of editor string
