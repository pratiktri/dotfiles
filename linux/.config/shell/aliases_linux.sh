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
        update_command="sudo dnf update && sudo dnf upgrade --refresh && sudo dnf autoremove"
    elif command -v apt-get >/dev/null 2>&1; then
        update_command="sudo apt-get update && sudo apt-get upgrade && sudo apt dist-upgrade && sudo apt autoremove"
    elif command -v zypper >/dev/null 2>&1; then
        update_command="sudo zypper refresh && sudo zypper dup"
    elif command -v pkg >/dev/null 2>&1; then
        update_command="sudo pkg update && sudo pkg upgrade && sudo pkg autoremove"
    fi

    eval "$update_command"
    echo ""

    command -v brew >/dev/null && brew update && brew upgrade && brew autoremove && brew cleanup && echo "Brew packages updated"
    echo ""

    # command -v flatpak >/dev/null && echo "Flatpak:" && flatpak update && flatpak uninstall --unused && flatpak --user uninstall --unused && flatpak repair
    # command -v npm >/dev/null && npm update -g
    command -v rustup >/dev/null && rustup update && echo "Rust updated"
    echo ""
}

# Update & Upgrades
autorem() {
    remove_command=""

    if command -v apt-get >/dev/null 2>&1; then
        remove_command="sudo apt autoremove"
    elif command -v dnf >/dev/null 2>&1; then
        remove_command="sudo dnf autoremove"
    elif command -v zypper >/dev/null 2>&1; then
        orphaned="$(zypper packages --orphaned | awk 'NR>4{print $5}' | grep -v '^$')"
        [ -n "$orphaned" ] && remove_command="sudo zypper rm $orphaned"
    elif command -v pkg >/dev/null 2>&1; then
        remove_command="sudo pkg autoremove"
    fi

    eval "$remove_command"
    flatpak uninstall --unused && flatpak --user uninstall --unused
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

pre_snap() {
    if ! command -v snapper >/dev/null 2>&1; then
        echo "snapper not found" >&2
        return 1
    fi

    desc="${1:-manual}"

    case "$desc" in
    [Pp]re*) ;; # already starts with Pre/pre, keep as-is
    *) desc="Pre $desc" ;;
    esac

    root_id=$(sudo snapper -c root create -t pre -d "$desc" -p 2>/dev/null)
    home_id=$(sudo snapper -c home create -t pre -d "$desc" -p 2>/dev/null)

    echo "root=$root_id home=$home_id"
}

post_snap() {
    if ! command -v snapper >/dev/null 2>&1 || ! command -v fzf >/dev/null 2>&1; then
        echo "Need both snapper & fzf installed" >&2
        return 1
    fi

    # Get pre-snapshots with number and description
    root_pres=$(sudo snapper -c root list --columns number,description | awk 'NR>2 && /[Pp]re/')
    home_pres=$(sudo snapper -c home list --columns number,description | awk 'NR>2 && /[Pp]re/')

    # Check if any pre-snapshots exist
    if [ -z "$root_pres" ] && [ -z "$home_pres" ]; then
        echo "No pre-snapshots found"
        return 1
    fi

    # Select root pre-snapshot (shows number and description)
    root_selection=$(echo "$root_pres" | fzf --prompt="Root pre-snapshot: " --header="NUM  DESCRIPTION")
    if [ -z "$root_selection" ]; then
        echo "No root pre-snapshot selected"
        return 1
    fi
    root_snap_id=$(echo "$root_selection" | awk '{print $1}')
    root_desc=$(echo "$root_selection" | sed 's/.*│ *//' | sed 's/^[Pp]re/Post/')

    # Select home pre-snapshot
    home_selection=$(echo "$home_pres" | fzf --prompt="Home pre-snapshot: " --header="NUM  DESCRIPTION")
    if [ -z "$home_selection" ]; then
        echo "No home pre-snapshot selected"
        exit 1
    fi
    home_snap_id=$(echo "$home_selection" | awk '{print $1}')
    home_desc=$(echo "$home_selection" | sed 's/.*│ *//' | sed 's/^[Pp]re/Post/')

    # Create post-snapshots
    sudo snapper -c root create -t post --pre-number "$root_snap_id" -c number --description "Post ${root_desc}" 2>/dev/null
    sudo snapper -c home create -t post --pre-number "$home_snap_id" -c number --description "Post ${home_desc}" 2>/dev/null

    echo "Created post-snapshots"

    # TIP: Restore both system files & application/user state
    # sudo snapper -c root undochange <pre_snap_id>..<post_snap_id>
    # sudo snapper -c home undochange <pre_snap_id>..<post_snap_id>
}

# Network
alias flush-dns="sudo systemd-resolve --flush-caches"
alias dnsreset="sudo systemctl restart dnscrypt-proxy"
alias dnscheck="dnscrypt-proxy -resolve google.com"
alias ips='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP:- "; curl -s https://ipinfo.io/ip'
alias ipdetails='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP Details:- \n"; geoip'
alias listening_apps="sudo netstat -nutlp | grep ':' | awk '{print \$1,\$4,\$NF}' | awk -F: '{print \$1,\$(NF-1),\$NF}' | awk -v OFS=\"\t\" 'BEGIN {printf (\"%s\t%s\t\t%s \n\", \"PROTO\", \"PORT\", \"APPLICATION\")} {print \$1 , \$(NF-1) ,\" \" , \$NF}' | (read -r; printf \"%s\n\" \"\$REPLY\"; sort -k2 -n)"
