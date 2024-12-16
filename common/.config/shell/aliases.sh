#!/bin/sh

# Generic
alias bashreload="source ~/.bashrc"
alias zshreload="source ~/.zshrc"
alias free="free -ht"
alias type="type -a"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# shellcheck disable=SC2142
alias usersearch="awk -F: '{print \"UserName: \" \$1 \", UserID: \" \$3 \", Home Dir: \" \$6 \", Shell Used: \" \$7}' /etc/passwd | grep"
alias untar='tar -zxvf '

alias v='$EDITOR'
alias snvim='${HOMEBREW_PREFIX}/bin/nvim' # Stable nvim

# Directories and Directory listings
alias ~="cd ~"
alias ..="cd .."
alias ...='cd ../../../' # Go back 3 directory levels
alias cl=clear

alias lsc='ls --color=auto --hyperlink'
alias ll='lsc -alhF'
alias la='lsc -Ah'
alias lsa="lsc -lAFhZ"

alias mkdir="mkdir -pv"
alias df="df -h"
mkcd() {
    mkdir "$1"
    cd "$1" || exit
}

# Network
alias ping="ping -c 10"
alias ping8="ping 8.8.8.8"
alias ping1="ping 1.1.1.1"
alias p8="ping8"
alias p1="ping1"
alias pubip="curl https://ipinfo.io/ip; echo"
alias speedtest="speedtest-cli --secure"
geoip() {
    curl -s https://ipinfo.io | sed '/readme\|loc\|postal\|{\|}\|hostname/d;s/org/ISP/;s/"\|,$//g' | awk -F ':' 'NF { printf("%10s: %s \n", $1, $2)}'
}
