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

# Sets environment variables for login non-interactive shells (VS Code & Zed)
[ -z "$XDG_CONFIG_HOME" ] && source "$HOME"/.profile

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
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
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

# Enable zmv (zsh batch-renamer)
autoload zmv

# Add brew provided autocompletions to path: must be before compinit
[[ ! -d  "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]] || FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"

# Zinit Plugins
zinit ice depth=1 ver"v1.20.0"; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light jimhester/per-directory-history

zinit wait lucid light-mode depth=1 for \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  OMZP::colored-man-pages \
  OMZP::gitignore \
  OMZP::sudo \
  OMZP::timer \
  OMZP::vi-mode \
  OMZP::docker \
  OMZP::fzf \
  OMZP::rust \
  OMZP::brew \
  OMZP::bun \
  OMZP::node \
  OMZP::podman

# TIP: execute `zinit update --all` quarterly

# Completion files: Use XDG dirs
ZCOMP_CACHE_HOME="${XDG_CACHE_HOME}/zsh"
ZCOMP_DUMP_FILE="${ZCOMP_CACHE_HOME}/zcompdump-$ZSH_VERSION"
ZCOMP_CACHE_FILE="${ZCOMP_CACHE_HOME}/zcompcache"
[ -d "${ZCOMP_CACHE_HOME}" ] || mkdir -p "${ZCOMP_CACHE_HOME}"

# ZSH Auto-completion settings: Do it AFTER plugin load, so all fpaths are included
autoload -Uz compinit                       # Initialized zsh completion
_comp_options+=(globdots)                   # Include hidden files
zmodload zsh/complist                       # Add enhancements to zsh completion system

# Run compinit only once daily; skip security check on fresh dump
if [[ -n $ZCOMP_DUMP_FILE(#qN.mh+24) ]]; then
  compinit -d "$ZCOMP_DUMP_FILE"
else
  compinit -C -d "$ZCOMP_DUMP_FILE"  # -C skips security check, reuses dump
fi

zinit cdreplay -q # Replay compdefs captured during Turbo load
(( ${+_comps} )) && _comps[zinit]=_zinit  # Register zinit completion

# Completion styling
zstyle ':completion:*' cache-path "$ZCOMP_CACHE_FILE"   # Sets path for completion cache files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case INsensitive completion match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Add color to completion suggestions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

# To customize prompt, run `p10k configure`
[[ ! -f "$XDG_CONFIG_HOME/shell/p10k.zsh" ]] || source "$XDG_CONFIG_HOME/shell/p10k.zsh"

# User configuration # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Source aliases and shell functions
for alias_file in "$XDG_CONFIG_HOME"/shell/*.sh; do source "$alias_file"; done

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^u' undo
# TIP:: zinit auto expands following when you `space`/`tab` after them
#       !* -> all arguments to previous command
#       !?search-term? -> Last command that contained `search-term`
#       !! -> Entire last command

# TIP: Following should be executed AFTER aliases are sourced
command -v op >/dev/null && bindkey -s '^o' ' op\n' # Fuzzyfind projects and open in nvim
command -v pnew >/dev/null && bindkey -s '^[o' ' pnew\n' # Create a new project quickly

# PERF: Part 2: Zsh Instrumentations
# unsetopt XTRACE
# exec 2>&3 3>&-
