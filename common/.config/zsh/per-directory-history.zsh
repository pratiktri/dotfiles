# From https://github.com/jimhester/per-directory-history

[[ -z $HISTORY_BASE ]] && HISTORY_BASE="$HOME/.directory_history"
[[ -z $HISTORY_START_WITH_GLOBAL ]] && HISTORY_START_WITH_GLOBAL=false
[[ -z $PER_DIRECTORY_HISTORY_TOGGLE ]] && PER_DIRECTORY_HISTORY_TOGGLE='^G'

function per-directory-history-toggle-history() {
  if [[ $_per_directory_history_is_global == true ]]; then
    _per-directory-history-set-directory-history
    _per_directory_history_is_global=false
    zle -I
    echo "using local history"
  else
    _per-directory-history-set-global-history
    _per_directory_history_is_global=true
    zle -I
    echo "using global history"
  fi
}

autoload per-directory-history-toggle-history
zle -N per-directory-history-toggle-history
bindkey "$PER_DIRECTORY_HISTORY_TOGGLE" per-directory-history-toggle-history
bindkey -M vicmd "$PER_DIRECTORY_HISTORY_TOGGLE" per-directory-history-toggle-history

_per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"

function _per-directory-history-change-directory() {
  _per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"
  mkdir -p "${_per_directory_history_directory:h}"
  if [[ $_per_directory_history_is_global == false ]]; then
    #save to the global history
    fc -AI "$HISTFILE"
    #save history to previous file
    local prev="$HISTORY_BASE${OLDPWD:A}/history"
    mkdir -p "${prev:h}"
    fc -AI "$prev"

    #discard previous directory's history
    local original_histsize=$HISTSIZE
    HISTSIZE=0
    HISTSIZE=$original_histsize

    #read history in new file
    if [[ -e "$_per_directory_history_directory" ]]; then
      fc -R "$_per_directory_history_directory"
    fi
  fi
}

function _per-directory-history-addhistory() {
  # respect hist_ignore_space
  if [[ -o hist_ignore_space ]] && [[ "$1" == \ * ]]; then
      true
  else
      print -Sr -- "${1%%$'\n'}"
      # instantly write history if set options require it.
      if [[ -o share_history ]] || \
         [[ -o inc_append_history ]] || \
         [[ -o inc_append_history_time ]]; then
          fc -AI "$HISTFILE"
          fc -AI "$_per_directory_history_directory"
      fi
      fc -p "$_per_directory_history_directory"
  fi
}

function _per-directory-history-precmd() {
  if [[ $_per_directory_history_initialized == false ]]; then
    _per_directory_history_initialized=true

    if [[ $HISTORY_START_WITH_GLOBAL == true ]]; then
      _per-directory-history-set-global-history
      _per_directory_history_is_global=true
    else
      _per-directory-history-set-directory-history
      _per_directory_history_is_global=false
    fi
  fi
}

function _per-directory-history-set-directory-history() {
  fc -AI "$HISTFILE"
  local original_histsize=$HISTSIZE
  HISTSIZE=0
  HISTSIZE=$original_histsize
  if [[ -e "$_per_directory_history_directory" ]]; then
    fc -R "$_per_directory_history_directory"
  fi
}

function _per-directory-history-set-global-history() {
  fc -AI "$_per_directory_history_directory"
  local original_histsize=$HISTSIZE
  HISTSIZE=0
  HISTSIZE=$original_histsize
  if [[ -e "$HISTFILE" ]]; then
    fc -R "$HISTFILE"
  fi
}

mkdir -p "${_per_directory_history_directory:h}"

#add functions to the exec list for chpwd and zshaddhistory
autoload -U add-zsh-hook
add-zsh-hook chpwd _per-directory-history-change-directory
add-zsh-hook zshaddhistory _per-directory-history-addhistory
add-zsh-hook precmd _per-directory-history-precmd

# set initialized flag to false
_per_directory_history_initialized=false
