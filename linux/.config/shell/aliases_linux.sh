#!/bin/bash

# Kitty & Ghostty terminfo aren't available on most servers
alias ssh="TERM=xterm-256color ssh"

# Directories and Directory listings
dir_size() {
    if [ "$1" = "" ]; then
        dir="$PWD"
    else
        dir="$1"
    fi

    du -ah "$dir" --max-depth=1 | sort -hr
}

up(){
    update_command=""

    # Detect package manager and set package manager commands
    if command -v dnf > /dev/null 2>&1; then
        update_command="sudo dnf upgrade --refresh && sudo dnf system-upgrade download --releasever=$(rpm -E %fedora) && sudo dnf autoremove"
    elif command -v pkcon > /dev/null 2>&1; then
        update_command="sudo pkcon refresh && sudo pkcon update && sudo apt dist-upgrade && sudo apt autoremove"
    elif command -v apt-get > /dev/null 2>&1; then
        update_command="sudo apt-get update && sudo apt-get upgrade && sudo apt dist-upgrade && sudo apt autoremove"
    elif command -v pkg > /dev/null 2>&1; then
        update_command="sudo pkg update && sudo pkg upgrade && sudo pkg autoremove"
    fi

    eval "$update_command"
    command -v brew > /dev/null && echo "Brew:" &&  brew update && brew upgrade && brew autoremove && brew cleanup
    command -v flatpak > /dev/null && echo "Flatpak:" && flatpak update && flatpak uninstall --unused && flatpak --user uninstall --unused && flatpak repair
    command -v npm > /dev/null && npm update -g
    command -v rustup >/dev/null && rustup update
}

# Update & Upgrades
autorem(){
    remove_command=""

    if command -v apt-get > /dev/null 2>&1; then
        remove_command="sudo apt autoremove"
    elif command -v dnf > /dev/null 2>&1; then
        remove_command="sudo dnf autoremove"
    elif command -v pkg > /dev/null 2>&1; then
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

    if command -v apt-get > /dev/null 2>&1; then
        sudo apt-get install "$1"
        os_install_status=$?
    elif command -v dnf > /dev/null 2>&1; then
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

# For servers
alias ngt="sudo nginx -t"
alias ngrestart="sudo systemctl restart nginx"
alias ngreload="sudo systemctl reload nginx"
alias ngstop="sudo systemctl stop nginx"

f2b_banned_ips() {
    provided_jail=$1

    if [ "${provided_jail// /}" != "" ]; then
        for ip in "$(sudo fail2ban-client status "$provided_jail" | tail -1 | sed 's/[^:]*://;s/\s*//')"
        do
            printf "%17s\n" "$ip"
        done
    else
        total_ips_banned=0
        for JAIL in "$(sudo fail2ban-client status | tail -1 | sed 's/[^:]*://;s/\s*//;s/,//g')"
        do
            banned_ip_count=$(sudo fail2ban-client status "$JAIL" | grep -oP 'Currently banned:\s*\K\d+')

            if [ "$banned_ip_count" -gt 0 ]; then
                echo "${JAIL}: ${banned_ip_count}"

                for ip in "$(sudo fail2ban-client status "$JAIL" | tail -1 | sed 's/[^:]*://;s/\s*//')"
                do
                    printf "%17s\n" "[$ip]"
                done

                total_ips_banned=$(( total_ips_banned + banned_ip_count ))

                echo
            else
                echo -e "${JAIL}:\n    -None-\n"
            fi
        done

        echo "Total IPs banned across all jails - ${total_ips_banned}"
    fi
}

f2b_unban_ip() {
    ip_to_unban="$1"
    jail="$2"

    # If jail is provided - use that jail to directly unban
    if [ "${jail// /}" != "" ]; then
        sudo fail2ban-client set "$jail" unbanip "$ip_to_unban" > /dev/null && echo "Successfully released ban"
    else
        # Find all JAILS this IP belong to
        # Unban the ip where ever it is found

        for JAIL in "$(sudo fail2ban-client status | tail -1 | sed 's/[^:]*://;s/\s*//;s/,//g')"
        do
            banned_ip_count=$(sudo fail2ban-client status "$JAIL" | grep -oP 'Currently banned:\s*\K\d+')
            if [ "$banned_ip_count" -gt 0 ] && [[ $(sudo fail2ban-client status "$JAIL") == *"$ip_to_unban"* ]]; then
                found_ip="true"
                echo "Unbanning from ${JAIL}:"
                sudo fail2ban-client set "$JAIL" unbanip "$ip_to_unban" > /dev/null && echo "Successfully released ban"
            fi
        done

        if [[ -z "${found_ip// /}" ]]; then
            echo "${ip_to_unban} was not found in any banned lists."
            echo "No action taken."
        fi
    fi
}

f2b_ban_an_ip(){
    ip_to_ban=$1
    ban_jail=$2

    if [[ ( -z "${ip_to_ban// /}" ) || ( -z "${ban_jail// /}" ) ]]; then
        echo "Please provide an IP and a Jail (in that order)"
        echo -e "eg -\n\t f2b_ban_an_ip 1.1.1.1 sshd"
        return 1
    fi

    sudo fail2ban-client set "$ban_jail" banip "$ip_to_ban" > /dev/null && echo "Ban successful"
}
