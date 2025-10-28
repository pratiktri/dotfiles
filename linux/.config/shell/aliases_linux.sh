#!/bin/bash

# Kitty & Ghostty terminfo aren't available on most servers
alias ssh="TERM=xterm-256color ssh"

alias ls='ls --color=auto --hyperlink'
alias ll='ls -alhF'
alias la='ls -Ah'
alias lsa="ls -lAFhZ"
alias printpath="echo $PATH | tr : '\n'"

# Templates
[ ! -f "${TEMPLATE_DIR}/.gitignore" ] || alias cp_git_ignore='cp ${TEMPLATE_DIR}/.gitignore . && echo ".gitignore added"'
[ ! -f "${TEMPLATE_DIR}/.prettierrc" ] || alias cp_prettier_rc='cp ${TEMPLATE_DIR}/.prettierrc . && echo ".prettierrc added"'
[ ! -f "${TEMPLATE_DIR}/.eslintrc.json" ] || alias cp_eslint='cp ${TEMPLATE_DIR}/.eslintrc.json . && echo ".eslintrc.json added"'
cp_docker_ignore() {
    local git_ignore_file

    if [ -f .gitignore ]; then
        git_ignore_file=.gitignore
    elif [ -f "${TEMPLATE_DIR}/.gitignore" ]; then
        git_ignore_file="${TEMPLATE_DIR}/.gitignore"
    else
        return 1
    fi

    cp "$git_ignore_file" .dockerignore
    cat <<EOF >>.dockerignore

# ---- Docker specific ----
git/
*.md
Dockerfile
EOF

    echo ".dockerignore added"
}

cp_prettier_ignore() {
    local git_ignore_file

    if [ -f .gitignore ]; then
        git_ignore_file=.gitignore
    elif [ -f "${TEMPLATE_DIR}/.gitignore" ]; then
        git_ignore_file="${TEMPLATE_DIR}/.gitignore"
    else
        return 1
    fi

    cp "$git_ignore_file" .prettierignore
    cat <<EOF >>.prettierignore

# ---- Prettier specific ----
*backup
*undo
*sessions
.prettierignore
package-lock.json
.prettierrc
EOF
    echo ".prettierignore added"
}

cp_git_precommit() {
    local template_file="${TEMPLATE_DIR}/pre-commit"
    if [ ! -f "$template_file" ]; then
        return 1
    fi

    if [ ! -d ".git" ]; then
        echo "Not a git repository"
        return 1
    fi

    local hooks_dir
    hooks_dir="$(pwd)/.git/hooks"

    if [ -f "$hooks_dir/$(basename "$template_file")" ]; then
        echo "pre-commit hook already exist"
        return 1
    fi

    cp "$template_file" "$hooks_dir" && printf "Pre-commit hook template copied to %s\n" "$hooks_dir"
}

# Coding
command -v tldr >/dev/null && alias tldr="tldr --platform=linux"
command -v tldr >/dev/null && alias h="tldr"
command -v fzf >/dev/null && alias path="printenv | grep ^PATH= | sed 's/^PATH=//' | tr ':' '\n' | fzf"
command -v podman >/dev/null && alias docker=podman

# Git
alias cd_root='cd $(git rev-parse --show-toplevel 2>/dev/null || echo ".")'
alias cd_git_root=cd_root

git_push_all_changes() {
    if [ -z "$1" ] || [ "$1" = " " ]; then
        echo "Please provide a commit message."
        return 126
    fi
    git add . && git commit -am "${1}" && git push
}

# Directories and Directory listings
dir_size() {
    if [ "$1" = "" ]; then
        dir="$PWD"
    else
        dir="$1"
    fi

    du -ah "$dir" --max-depth=1 | sort -hr
}

up() {
    update_command=""

    # Detect package manager and set package manager commands
    if command -v dnf >/dev/null 2>&1; then
        update_command="sudo dnf upgrade --refresh && sudo dnf system-upgrade download --releasever=$(rpm -E %fedora) && sudo dnf autoremove"
    elif command -v pkcon >/dev/null 2>&1; then
        update_command="sudo pkcon refresh && sudo pkcon update && sudo apt dist-upgrade && sudo apt autoremove"
    elif command -v apt-get >/dev/null 2>&1; then
        update_command="sudo apt-get update && sudo apt-get upgrade && sudo apt dist-upgrade && sudo apt autoremove"
    elif command -v pkg >/dev/null 2>&1; then
        update_command="sudo pkg update && sudo pkg upgrade && sudo pkg autoremove"
    fi

    eval "$update_command"
    command -v brew >/dev/null && echo "Brew:" && brew update && brew upgrade && brew autoremove && brew cleanup
    command -v flatpak >/dev/null && echo "Flatpak:" && flatpak update && flatpak uninstall --unused && flatpak --user uninstall --unused && flatpak repair
    command -v npm >/dev/null && npm update -g
    command -v rustup >/dev/null && rustup update
}

# Update & Upgrades
autorem() {
    remove_command=""

    if command -v apt-get >/dev/null 2>&1; then
        remove_command="sudo apt autoremove"
    elif command -v dnf >/dev/null 2>&1; then
        remove_command="sudo dnf autoremove"
    elif command -v pkg >/dev/null 2>&1; then
        remove_command="sudo pkg autoremove"
    fi

    eval "$remove_command"
    flatpak uninstall --unused && flatpak --user uninstall --unused
}

install() {
    if [ -z "$1" ]; then
        echo "No program name provided."
        return 1
    fi

    if command -v "$1" >/dev/null 2>&1; then
        echo "The program '$1' is already installed."
        type "$1"
        return 1
    fi

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install "$1"
        os_install_status=$?
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install "$1"
        os_install_status=$?
    else
        log "Unsupported package manager. This script supports apt, yum, and dnf."
        exit 1
    fi

    if [ "$os_install_status" = 0 ]; then
        return 0
    fi

    # Try to install through brew if OS install failed
    if brew install "$1"; then
        return 0
    fi

    echo
    echo "$1 could not be installed using the OS package manager or Homebrew."
    return 1
}

remove() {
    if [ -z "$1" ]; then
        echo "No program name provided."
        return 1
    fi

    # Determine the package manager and distribution
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get remove "$1"
    elif command -v yum >/dev/null 2>&1; then
        sudo yum remove "$1"
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf remove "$1"
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper remove "$1"
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -R "$1"
    else
        echo "Unsupported package manager or distribution."
        return 1
    fi

    brew remove "$1"
    flatpak uninstall --user "$1"
    flatpak uninstall "$1"
}

# Network
alias flush-dns="sudo systemd-resolve --flush-caches"
alias dnsreset="sudo systemctl restart dnscrypt-proxy"
alias dnscheck="dnscrypt-proxy -resolve google.com"
alias ips='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP:- "; curl -s https://ipinfo.io/ip'
alias ipdetails='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP Details:- \n"; geoip'
alias listening_apps="sudo netstat -nutlp | grep ':' | awk '{print \$1,\$4,\$NF}' | awk -F: '{print \$1,\$(NF-1),\$NF}' | awk -v OFS=\"\t\" 'BEGIN {printf (\"%s\t%s\t\t%s \n\", \"PROTO\", \"PORT\", \"APPLICATION\")} {print \$1 , \$(NF-1) ,\" \" , \$NF}' | (read -r; printf \"%s\n\" \"\$REPLY\"; sort -k2 -n)"
