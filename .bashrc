# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" != yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################################################################################
################################################################################
############### Everything below this line are customizations
################################################################################
################################################################################

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignorespace
HISTTIMEFORMAT="%H:%M:%S(%z)%d-%b-%y "

# Do not let globbing complain on no match
shopt -s nullglob

## When only a directory is entered without cd, cd into it
shopt -s autocd

function timer_start {
  timer=${timer:-$SECONDS}
}

trap 'timer_start' DEBUG

PROMPT_COMMAND=jazz_my_prompt

jazz_my_prompt() {
  # Capture exit code of last command
  # Below MUST be the 1st line of the function
  local ex=$?

  # Capture the last command's execution time
  timer_show=$(($SECONDS - $timer))
  unset timer

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
  if [[ "$ex" -eq 0 ]]
  then
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
  group9="${groupstart}${normalwhite}${timer_show}s${groupend}"

  # Position each group where you would like them
  PS1="\n${group1}-${group2}-${group3}-${group4}-${group5}\n${group6}-${group9}-${group8}\n${isroot}${reset} "
}

[[ ! -f ~/.set_path ]] || source ~/.set_path

[[ ! -f ~/.aliases ]] || source ~/.aliases
[[ ! -f ~/.aliases_personal ]] || source ~/.aliases_personal
[[ ! -f ~/.neon_alias ]] || source ~/.neon_alias

[[ ! -f ~/.gosetup ]] || source ~/.gosetup
[[ ! -f ~/.flutterpathsetup ]] || source ~/.flutterpathsetup

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# Kubernetes Autocompletion
source <(kubectl completion bash)

source ~/.env