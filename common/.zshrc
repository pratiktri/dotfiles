#!/bin/zsh

# TIP: time zsh -i -c exit # Shows how long took to start zsh

# PERF: Part 1: Zsh Instrumentation => Part 2 at bottom of the file
# zmodload zsh/zprof

# --- Sets environment variables ---
[ -z "$XDG_CONFIG_HOME" ] && source "$HOME"/.profile

mkdir -p \
    "$XDG_DATA_HOME/zsh/completions" \
    "$XDG_DATA_HOME/zsh/plugins" \
    "$XDG_STATE_HOME/shell" \
    "$XDG_CACHE_HOME/zsh"

ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"
ZSH_STATE_HOME="$XDG_STATE_HOME/shell"
ZSH_PLUGIN_HOME="$XDG_DATA_HOME/zsh/plugins"
ZSH_COMPLETION_HOME="$XDG_DATA_HOME/zsh/completions"
ZCOMP_CACHE_HOME="${XDG_CACHE_HOME}/zsh"
ZCOMP_DUMP_FILE="${ZCOMP_CACHE_HOME}/zcompdump-$ZSH_VERSION"
ZCOMP_CACHE_FILE="${ZCOMP_CACHE_HOME}/zcompcache"

# --- ZSH Options ---
setopt +o nomatch  # Unmatched glob patterns like bash
setopt noglobalrcs # Don't source global rc files from /etc/z*

# General
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"

# History
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HIST_STAMPS="dd.mm.yyyy" # see 'man strftime' for details.
export HISTFILE="$ZSH_STATE_HOME/zsh_history"
setopt APPENDHISTORY      # Append rather than overwriting
setopt SHAREHISTORY       # Share history between all sessions.
setopt EXTENDED_HISTORY   # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY        # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_SPACE  # Don't add commands that start with whitespace to history
setopt HIST_FIND_NO_DUPS  # Don't show duplicate commands when searching history

# Enable zmv (zsh batch-renamer)
autoload zmv

# --- Download Plugins ---
# Install plugins once - doesn't update
_zsh_plugin_install() {
    local name="$1"
    local repo="$2"
    local dest="$XDG_DATA_HOME/zsh/plugins/$name"
    [[ -d "$dest/.git" ]] && return
    echo "Installing zsh plugin: $name"
    git clone --depth=1 "$repo" "$dest"
}

_zsh_plugin_install powerlevel10k https://github.com/romkatv/powerlevel10k.git

# --- Completions ---
[[ ! -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]] || FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"

# Auto-generate completions - once
_gen_completion() {
    local cmd="$1"
    local out="$2"
    shift 2

    [[ -f "$out" ]] && return
    command -v "$cmd" &>/dev/null || return
    mkdir -p "${out:h}"
    # $@ is the completion command args
    "$@" >"$out"
}

_gen_completion docker "$ZSH_COMPLETION_HOME/_docker" docker completion zsh
_gen_completion podman "$ZSH_COMPLETION_HOME/_podman" podman completion zsh
_gen_completion rustup "$ZSH_COMPLETION_HOME/_rustup" rustup completions zsh
_gen_completion rustup "$ZSH_COMPLETION_HOME/_cargo" rustup completions zsh cargo

fpath=("$ZSH_COMPLETION_HOME" $fpath)

# Completion styling - set BEFORE compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZCOMP_CACHE_FILE"   # Sets path for completion cache files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case INsensitive completion match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Add color to completion suggestions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

_comp_options+=(globdots) # Include hidden files
zmodload zsh/complist     # Add enhancements to zsh completion system
autoload -Uz compinit     # Initialized zsh completion

# Defer compinit until after first prompt
typeset -g _zsh_comp_loaded=0
function _zsh_deferred_compinit {
    [[ $_zsh_comp_loaded -eq 1 ]] && return
    _zsh_comp_loaded=1
    if [[ -n $ZCOMP_DUMP_FILE(#qN.mh+24) ]]; then
        compinit -C -d "$ZCOMP_DUMP_FILE"
    else
        compinit -d "$ZCOMP_DUMP_FILE"
    fi
}
precmd_functions+=(_zsh_deferred_compinit)

# --- Source Plugins (downloaded + static) ---
# Powerlevel10k
source "$ZSH_PLUGIN_HOME/powerlevel10k/powerlevel10k.zsh-theme"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Source repo local plugins ---
# Per-directory history
HISTORY_BASE="$ZSH_STATE_HOME/per-directory-history"

# Timer configurations
TIMER_PRECISION=3
TIMER_FORMAT='[%d]'

# Source repo plugins
for plugins in "$ZSH_CONFIG_HOME"/*.zsh; do source "$plugins"; done

# --- User configuration ---

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# Source aliases and shell functions
for alias_file in "$XDG_CONFIG_HOME"/shell/*.sh; do source "$alias_file"; done

# --- Keybindings ---
# vi-mode
bindkey -v
bindkey -M viins '^p' up-line-or-history
bindkey -M viins '^n' down-line-or-history
bindkey -M viins '^w' backward-kill-word
bindkey -M vicmd 'C' backward-kill-line
bindkey -M vicmd 'A' end-of-line

bindkey '^f' autosuggest-accept
bindkey '^u' undo
# TIP:: zsh auto expands following when you `space`/`tab` after them
#       !* -> all arguments to previous command
#       !?search-term? -> Last command that contained `search-term`
#       !! -> Entire last command

# TIP: Following should be executed AFTER aliases are sourced
command -v op >/dev/null && bindkey -s '^o' ' op\n'      # Fuzzyfind projects and open in nvim
command -v pnew >/dev/null && bindkey -s '^[o' ' pnew\n' # Create a new project quickly

# PERF: Part 2: Zsh Instrumentations
# zprof
