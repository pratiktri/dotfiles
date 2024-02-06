#!/bin/sh

# Directories and Directory listings
dir_size() {
	local dir
	if [ -z "$1" ]; then
		dir="${PWD}"
	else
		dir="$1"
	fi

	du -ah "${dir}" -d 1 | sort -hr
}

# Update & Upgrades
alias up="brew upgrade --cask && brew upgrade --formula && brew autoremove && brew cleanup && rustup update && npm update -g"