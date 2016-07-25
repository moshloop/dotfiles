#!/bin/zsh
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

autoload -U "$ZSH"/functions/*(:t)
# Record each line as it gets issued
PROMPT_COMMAND='history -a'
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=$HISTSIZE
HISTFILESIZE=100000
HISTTIMEFORMAT='%F %T '

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:cd:zz"

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
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