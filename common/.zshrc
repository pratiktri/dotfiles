# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/pratik/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
POWERLEVEL9K_MODE='awesome-fontconfig'
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
plugins=(
    git
    docker
    history
    per-directory-history
    perms
    sudo
    systemd
    zsh-syntax-highlighting
    zsh-autosuggestions
    vi-mode
    # exercism
)

source $ZSH/oh-my-zsh.sh

# User configuration

##############Pratik POWERLEVEL9K Configs####################################
POWERLEVEL9K_INSTANT_PROMPT=off

POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S %a}"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=6

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon user ssh dir_writable dir background_jobs docker_machine command_execution_time time newline history status root_indicator)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

##############Pratik POWERLEVEL9K Configs END################################

setopt +o nomatch

# Higher History
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt EXTENDED_HISTORY           # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY         # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY              # Share history between all sessions.
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_SPACE          # Don't add commands that start with whitespace to history

##############Bring all the alias and setup scripts################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enable vi-mode
bindkey -v

# Setup path and export variables
[[ ! -f ~/.env ]] || source ~/.env
[[ ! -f ~/.set_path ]] || source ~/.set_path
[[ ! -f "$HOME/.cargo/env" ]] || source "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
PATH=$(pyenv root)/shims:$PATH

# Aliases
[[ ! -f ~/.aliases ]] || source ~/.aliases
[[ ! -f ~/.aliases_mac ]] || source ~/.aliases_mac
[[ ! -f ~/.aliases_neon ]] || source ~/.aliases_neon
[[ ! -f ~/.aliases_personal ]] || source ~/.aliases_personal

# nvm Setup
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ ! -f ~/.config/exercism/exercism_completion.bash ]] || source ~/.config/exercism/exercism_completion.bash

eval "$(ssh-agent -s)" > /dev/null
ulimit -n 10240
