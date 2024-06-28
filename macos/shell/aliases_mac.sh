#!/bin/sh

# Directories and Directory listings
dir_size() {
    if [ "$1" = "" ]; then
        dir="$PWD"
    else
        dir="$1"
    fi

    du -ah "$dir" -d 1 | sort -hr
}
alias tldr="tldr --platform=osx "

# Update & Upgrades
alias up="brew upgrade --cask && brew upgrade --formula && brew autoremove && brew cleanup && rustup update && npm update -g"
