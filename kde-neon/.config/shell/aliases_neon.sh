#!/bin/sh

# Directories and Directory listings
dir_size(){
    if [ "$1" = "" ]; then
        dir="$PWD"
    else
        dir="$1"
    fi

    du -ah "$dir" --max-depth=1 | sort -hr
}

# Network
alias flush-dns="sudo systemd-resolve --flush-caches"
alias dnsreset="sudo systemctl restart dnscrypt-proxy"
alias dnscheck="dnscrypt-proxy -resolve google.com"
alias ips='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP:- "; curl -s https://ipinfo.io/ip'
alias ipdetails='printf "Local IP:- "; hostname -I | cut -f1 -d " "; printf "Public IP Details:- \n"; geoip'
alias listening_apps="sudo netstat -nutlp | grep ':' | awk '{print \$1,\$4,\$NF}' | awk -F: '{print \$1,\$(NF-1),\$NF}' | awk -v OFS=\"\t\" 'BEGIN {printf (\"%s\t%s\t\t%s \n\", \"PROTO\", \"PORT\", \"APPLICATION\")} {print \$1 , \$(NF-1) ,\" \" , \$NF}' | (read -r; printf \"%s\n\" \"\$REPLY\"; sort -k2 -n)"


# Update & Upgrades
alias up="sudo pkcon refresh && sudo pkcon update && sudo apt dist-upgrade && sudo apt autoremove && rustup update && brew upgrade && brew autoremove && brew cleanup && npm update -g"
alias distup="sudo apt dist-upgrade"
alias autorem="sudo apt autoremove"
alias update="sudo apt-get update"
alias install="sudo apt-get install "
alias remove="sudo apt-get remove "


# For servers
alias ngt="sudo nginx -t"
alias ngrestart="sudo systemctl restart nginx"
alias ngreload="sudo systemctl reload nginx"
alias ngstop="sudo systemctl stop nginx"
alias fpmreset71="sudo systemctl restart php7.1-fpm"
alias fpmreset72="sudo systemctl restart php7.2-fpm"
alias fpmreset73="sudo systemctl restart php7.3-fpm"
alias fpmreset74="sudo systemctl restart php7.4-fpm"

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
