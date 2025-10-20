[ -z "$XDG_CONFIG_HOME" ] && source "$HOME"/.profile

[ -f /etc/bashrc ] && . /etc/bashrc

shopt -s histappend
shopt -s checkwinsize

case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

unset color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

############### Everything below this line are customizations ##################

# Do not let globbing complain on no match
shopt -s nullglob

## When only a directory is entered without cd, cd into it
shopt -s autocd

PROMPT_COMMAND=jazz_my_prompt

jazz_my_prompt() {
    # Capture exit code of last command
    # Below MUST be the 1st line of the function
    local ex=$?

    #----------------------------------------------------------------------------#
    # Bash text colour specification:  \e[<COLOUR>;<STYLE>m
    # Colours: 31=red, 32=green, 33=yellow, 34=blue, 35=purple, 36=cyan, 37=white
    # Styles:  0=normal, 1=bold, 2=dimmed, 4=underlined, 7=highlighted
    #----------------------------------------------------------------------------#

    local reset="\[\e[0m\]"
    local normal=';0m'
    local bold=';1m'
    local boldyellow="\[\e[32${bold}\]"
    local boldwhite="\[\e[37${bold}\]"
    local normalwhite="\[\e[37${normal}\]"
    local yellow_highlight="\[\e[31;7m\]"

    # Add color preference BEFORE the item
    local hostname="${normalwhite}\h"
    local username="${boldwhite}\u"
    local jobs="${boldwhite}jobs:\j"
    local history_cnt="${normalwhite}!\!"
    local timestamp="${normalwhite}\D{%H:%M:%S(%z) %d%b}"
    local session_cmd_cnt="${normalwhite}#\#"
    local pwd="${boldwhite}\w"
    local isroot="${boldwhite}\$"

    # Set prompt content
    # If exit code of last command is non-zero, prepend this code to the prompt
    local exit_code=''
    if [[ "$ex" -eq 0 ]]; then
        exit_code="${boldwhite}✓"
    else
        exit_code="${yellow_highlight}✗ $ex\a${reset}"
    fi

    # Style each group separately
    local groupstart="${boldyellow}["
    local groupend="${boldyellow}]"
    group1="${groupstart}${username}@${hostname}${groupend}"
    group2="${groupstart}${jobs}${groupend}"
    group3="${groupstart}${history_cnt}${groupend}"
    group4="${groupstart}${session_cmd_cnt}${groupend}"
    group5="${groupstart}${timestamp}${groupend}"
    group6="${groupstart}${exit_code}${groupend}"
    group8="${groupstart}${pwd}${groupend}"

    # Position each group where you would like them
    PS1="\n${group1}-${group2}-${group3}-${group4}-${group5}\n${group6}-${group9}-${group8}\n${isroot}${reset} "
}

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignorespace
HISTTIMEFORMAT="%H:%M:%S(%z)%d-%b-%y "
HISTFILE="$XDG_STATE_HOME/shell/bash_history"

[ ! -f "$XDG_CONFIG_HOME/exercism/exercism_completion.bash" ] || source "$XDG_CONFIG_HOME/exercism/exercism_completion.bash"

# [ctrl+r]: Search command history
# [ctrl+t]: fzf & over the files & directories under the current one & paste it to prompt
# [alt+c] : fzf & cd into a directory under the current one
command -v fzf >/dev/null && eval "$(fzf --bash)"

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd bash)"

# Source aliases and shell functions
for alias_file in "$XDG_CONFIG_HOME"/shell/*.sh; do source "$alias_file"; done

# TIP: Should be executed AFTER aliases are sourced
command -v op >/dev/null && bind '"^O":"op\n"'      # Fuzzyfind projects and open in nvim
command -v pnew >/dev/null && bind '"^[o":"pnew\n"' # Create a new project quickly
