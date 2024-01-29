# I'm not using a separate .zprofile; reuse the .profile instead
[ ! -f "$HOME/.profile" ] || source "$HOME/.profile"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$XDG_DATA_HOME/shell/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
source "${ZSH_CUSTOM}/themes/powerlevel10k/powerlevel10k.zsh-theme"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

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
plugins=(
    git
    # dotenv
    # dotnet
    gitignore
    # colored-man-pages
    docker
    # fd
    per-directory-history
    # ripgrep
    sudo
    zsh-syntax-highlighting
    zsh-autosuggestions
    vi-mode
    exercism
)
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_INSERT=3
HISTORY_BASE="$XDG_STATE_HOME/shell/per-directory-history"

# NOTE: Should be exported before sourcing oh-my-zsh, to avoid the dumpfiles on $HOME
export ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/zcompdump-$HOST

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure`
[[ ! -f "$XDG_CONFIG_HOME/shell/p10k.zsh" ]] || source "$XDG_CONFIG_HOME/shell/p10k.zsh"

# User configuration

setopt +o nomatch

# Higher History
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILE="$XDG_STATE_HOME/shell/zsh_history"
setopt EXTENDED_HISTORY           # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY         # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY              # Share history between all sessions.
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_SPACE          # Don't add commands that start with whitespace to history

# enable vi-mode
bindkey -v

# Basic auto/tab completions
autoload -U compinit
zstyle ':completion:*' menu select cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)  # Include hidden files

# [ctrl+r]:replaces shell command search
# [ctrl+t]:fzf & over the files & directories under the current one & paste it to prompt
# [alt+c] :fzf & cd into a directory under the current one
[ -f $XDG_STATE_HOME/shell/fzf.zsh ] && source $XDG_STATE_HOME/shell/fzf.zsh

# FPATH="$FPATH:$HOMEBREW_PREFIX/share/zsh/site-functions" # TODO: Make the completions here work

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# TODO: Use fzf + fd + kitty to auto create kitty sessions: use only the following directories
# 1. /media/pratik/Office/Code/
# 2. /media/pratik/Projects/LearningProjects/
# 3. /media/pratik/Projects/PersonalProjects/
# 4. /media/pratik/Projects/Interviews/
# - Ignore hidden directories
# - Put it in one of the aliases

