#!/bin/zsh

# TIP: time zsh -i -c exit # Shows how long took to start zsh

# PERF: Part 1: Zsh Instrumentation => Part 2 at bottom of the file
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '
# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile
# setopt XTRACE

# ZSH Options # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
bindkey -v                  # enable vi-mode
setopt +o nomatch           # Unmatched glob patterns like bash
setopt noglobalrcs          # Don't source global rc files from /etc/z*

ZSH_STATE_HOME="$XDG_STATE_HOME/shell"
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"

# ZSH History
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HIST_STAMPS="dd.mm.yyyy" # see 'man strftime' for details.
export HISTFILE="$ZSH_STATE_HOME/zsh_history"
setopt APPENDHISTORY        # Append rather than overwriting
setopt SHAREHISTORY         # Share history between all sessions.
setopt EXTENDED_HISTORY     # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY   # Write to the history file immediately, not when the shell exits.
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY          # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_SPACE    # Don't add commands that start with whitespace to history
setopt HIST_FIND_NO_DUPS    # Don't show duplicate commands when searching history

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit: ZSH Plugin Manager # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
ZINIT_HOME="${XDG_DATA_HOME}/shell/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugin settings
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_INSERT=3
TIMER_PRECISION=3; TIMER_FORMAT='[%d]'
HISTORY_BASE="$ZSH_STATE_HOME/per-directory-history"

# Zinit Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light jimhester/per-directory-history
# zinit ice depth=1; zinit light atuinsh/atuin

zinit ice wait lucid depth=1; zinit light zsh-users/zsh-completions
zinit ice wait lucid depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid depth=1; zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid depth=1; zinit snippet OMZP::colored-man-pages
zinit ice wait lucid depth=1; zinit snippet OMZP::command-not-found
zinit ice wait lucid depth=1; zinit snippet OMZP::dotenv
zinit ice wait lucid depth=1; zinit snippet OMZP::gitignore
zinit ice wait lucid depth=1; zinit snippet OMZP::sudo
zinit ice wait lucid depth=1; zinit snippet OMZP::timer
zinit ice wait lucid depth=1; zinit snippet OMZP::urltools
zinit ice wait lucid depth=1; zinit snippet OMZP::vi-mode

# Completions
zinit ice wait lucid depth=1; zinit snippet OMZP::podman
zinit ice wait lucid depth=1; zinit snippet OMZP::dotnet
zinit ice wait lucid depth=1; zinit snippet OMZP::fzf

# TIP: execute `zinit update --all` quarterly

# Add brew provided autocompletions to path
[[ ! -d  "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]] || FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"

# ZSH Auto-completion settings: Do it AFTER plugin load, so all fpaths are included
autoload -Uz compinit                       # Initialized zsh completion
(( ${+_comps} )) && _comps[zinit]=_zinit    # Sets up completion for Zinit
_comp_options+=(globdots)                   # Include hidden files
zmodload zsh/complist                       # Add enhancements to zsh completion system

# Completion files: Use XDG dirs
ZCOMP_CACHE_HOME="${XDG_CACHE_HOME}/zsh"
ZCOMP_CACHE_FILE="${ZCOMP_CACHE_HOME}/zcompcache"
[ -d "${ZCOMP_CACHE_HOME}" ] || mkdir -p "${ZCOMP_CACHE_HOME}"

# Run compinit only once daily
if [[ -n $ZCOMP_CACHE_HOME/zcompdump-$ZSH_VERSION(#qN.mh+24) ]]; then
  compinit -d "$ZCOMP_CACHE_HOME/zcompdump-$ZSH_VERSION"
else
  compinit -C   # Generate dumpfile only if outdated
fi

zinit cdreplay -q # Replay stored compdef. Must be AFTER compinit -d

# Completion styling
zstyle ':completion:*' cache-path "$ZCOMP_CACHE_FILE"   # Sets path for completion cache files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case INsensitive completion match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Add color to completion suggestions
zstyle ':completion::complete:*' gain-privileges 1 menu select cache-path "$ZCOMP_CACHE_FILE" # Enable completion for sudo commands

# To customize prompt, run `p10k configure`
[[ ! -f "$XDG_CONFIG_HOME/shell/p10k.zsh" ]] || source "$XDG_CONFIG_HOME/shell/p10k.zsh"

# User configuration # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Source aliases and shell functions
for alias_file in "$XDG_CONFIG_HOME"/shell/*.sh; do source "$alias_file"; done

# Keybindings
bindkey '^f' autosuggest-accept

# TIP: Following should be executed AFTER aliases are sourced
command -v op >/dev/null && bindkey -s '^o' ' op\n' # Fuzzyfind projects and open in nvim
command -v pnew >/dev/null && bindkey -s '^[o' ' pnew\n' # Create a new project quickly

# PERF: Part 2: Zsh Instrumentations
# unsetopt XTRACE
# exec 2>&3 3>&-
