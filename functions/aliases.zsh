
BOLD='\E[1m'
ital='\E[3m'
red='\E[0;31m'      # red
RED='\E[1;31m'      # red and bold
green='\E[0;32m'    # green
GREEN='\E[1;32m'    # green and bold
blue='\E[0;34m'     # blue
BLUE='\E[1;34m'     # blue and bold
cyan='\E[0;36m'     # cyan
CYAN='\E[1;36m'     # cyan and bold
NA='\E(B\E[m'       # No attributes


bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)


e_header() { printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"}
e_arrow() { printf "➜ $@\n"}
e_success() { printf "${green}✔ %s${reset}\n" "$@"}
e_error() { printf "${red}✖ %s${reset}\n" "$@"}
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"}
e_bold() { printf "${bold}%s${reset}\n" "$@"}
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"}

info () {
    # shellcheck disable=SC2059
    printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
    # shellcheck disable=SC2059
    printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    # shellcheck disable=SC2059
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
}

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

#!/bin/sh
# credit: http://nparikh.org/notes/zshrc.txt
# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is Mac OS X-specific.
extract () {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                        ;;
            *.tar.gz)   tar -zxvf "$1"                        ;;
            *.bz2)      bunzip2 "$1"                          ;;
            *.dmg)      hdiutil mount "$1"                    ;;
            *.gz)       gunzip "$1"                           ;;
            *.tar)      tar -xvf "$1"                         ;;
            *.tbz2)     tar -jxvf "$1"                        ;;
            *.tgz)      tar -zxvf "$1"                        ;;
            *.zip)      unzip "$1"                            ;;
            *.ZIP)      unzip "$1"                            ;;
            *.pax)      pax -r < "$1"                         ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
            *.Z)        uncompress "$1"                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function myip() # Get IP adresses.
{
    ETH=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' | \
    sed -e s/addr://)
    
    WLAN=$(/sbin/ifconfig wlan0 | awk '/inet/ { print $2 } ' | \
    sed -e s/addr://)
    echo -e "${BOLD}Local eth0 IP Address: ${NA}${cyan} `echo ${ETH:-'Not connected'}`$NA"
    echo -e "${BOLD}Local wlan0 IP Address:${NA}${cyan} `echo ${WLAN:-'Not connected'}`$NA"
}


function transfer() {
    if [ $# -eq 0 ]; then
        e_error 'No arguments specified'
        echo  Usage:  transfer test.txt
        return
    fi
    tmpfile=$( mktemp -t transferXXX );
    if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g');
        curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile;
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ;
    fi;
    cat $tmpfile;
    rm -f $tmpfile;
}


server() {
    local port="${1-8000}"
    python -m SimpleHTTPServer "$port" &
    open "http://localhost:$port"
}

function epoch() {
    echo `python -c "import time; print  ('{:0.0f}'.format(time.time() * 1000))"`
}


function stopwatch() {
    BEGIN=$1
    NOW=`epoch`
    let DIFF=$(( $NOW - $BEGIN ))
    # \r  is a "carriage return" - returns cursor to start of line
    printf "\e[36m\r %02dms" $DIFF
}

#!/bin/sh
# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
title() {
    # escape '%' chars in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}
    
    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")
    
    case $TERM in
        screen)
            print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
        ;;
        xterm*|rxvt)
            print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
        ;;
    esac
}


