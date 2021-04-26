#!/bin/zsh
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

# autoload -U "$ZSH"/functions/*(:t)
# Record each line as it gets issued
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILESIZE=$SAVEHIST
HISTTIMEFORMAT='%F %T '


# Don't record some commands
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:cd:zz"

# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY

# adds history incrementally and share it across sessions
# setopt INC_APPEND_HISTORY SHARE_HISTORY
# don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE


# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS

setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

# dont ask for confirmation in rm globs*
setopt RM_STAR_SILENT


# ignore case
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# menu if nb items > 2
zstyle ':completion:*' menu select=2
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select



unset AUTOSUGGESTION_HIGHLIGHT_COLOR
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=bg=8
unset AUTOSUGGESTION_HIGHLIGHT_CURSOR
