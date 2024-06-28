#!/bin/zsh
# I'm not using a separate .zprofile; reuse the .profile instead
[[ ! -f "$HOME/.profile" ]] || source "$HOME/.profile"

# ZSH Options
bindkey -v                  # enable vi-mode
setopt +o nomatch

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy" # see 'man strftime' for details.

# ZSH History
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HISTFILE="$XDG_STATE_HOME/shell/zsh_history"
setopt appendhistory        # Append rather than overwriting
setopt sharehistory         # Share history between all sessions.
setopt extended_history     # Write the history file in the ":start:elapsed;command" format.
setopt inc_append_history   # Write to the history file immediately, not when the shell exits.
setopt hist_reduce_blanks   # Remove superfluous blanks before recording entry.
setopt hist_verify          # Don't execute immediately upon history expansion.
setopt hist_ignore_space    # Don't add commands that start with whitespace to history
setopt hist_find_no_dups    # Don't show duplicate commands when searching history

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit ZSH Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME}/shell/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugin settings
TIMER_PRECISION=3; TIMER_FORMAT='[%d]'
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_INSERT=3
# Having HISTORY_BASE after per-directory-history plugin install does NOT work
HISTORY_BASE="$XDG_STATE_HOME/shell/per-directory-history"

# Zinit Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Oh-my-zsh plugins
zi snippet OMZP::colored-man-pages
zi snippet OMZP::command-not-found
zi snippet OMZP::gitignore
zi snippet OMZP::kitty
zi snippet OMZP::podman
zi snippet OMZP::rust
zi snippet OMZP::sudo
zi snippet OMZP::systemd
zi snippet OMZP::timer
zi snippet OMZP::vi-mode
zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/per-directory-history/per-directory-history.zsh

zi ice as"completion"
zi snippet OMZP::fd/_fd

# ZSH Auto-completion settings
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)   # Include hidden files
zmodload zsh/complist
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'      # Case INsensitive completion match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Add color to completion suggestions
zstyle ':completion::complete:*' gain-privileges 1 menu select cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# To customize prompt, run `p10k configure`
[[ ! -f "$XDG_CONFIG_HOME/shell/p10k.zsh" ]] || source "$XDG_CONFIG_HOME/shell/p10k.zsh"

# User configuration

# Add brew provided autocompletions to path
[[ ! -d  "/home/linuxbrew/.linuxbrew/share/zsh/site-functions" ]] || FPATH="/home/linuxbrew/.linuxbrew/share/zsh/site-functions:$FPATH"

# [ctrl+r]: Search command history
# [ctrl+t]: fzf & over the files & directories under the current one & paste it to prompt
# [alt+c] : fzf & cd into a directory under the current one
command -v fzf > /dev/null && eval "$(fzf --zsh)"

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Source aliases and shell functions
for alias_file in "$XDG_CONFIG_HOME"/shell/*.sh; do source "$alias_file"; done

# Keybindings
bindkey '^f' autosuggest-accept         #
bindkey '^p' history-search-backward    # Ctrl+p gets the last history match
bindkey '^n' history-search-forward     # Ctrl+n gets the next history match
# TIP: Following should be executed AFTER aliases are sourced
command -v op >/dev/null && bindkey -s '^o' ' op\n' # Fuzzyfind projects and open in nvim
command -v pnew >/dev/null && bindkey -s '^[o' ' pnew\n' # Create a new project quickly
