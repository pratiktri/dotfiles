# set PATH so it includes user's private bin if it exists
[ ! -d "$HOME/bin" ] || PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
[ ! -d "$HOME/.local/bin" ] || PATH="$HOME/.local/bin:$PATH"

# Set the config directory enviroment variable
[ ! -z "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"

# Set the cache directory enviroment variable
[ ! -z "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"

# Set the data directory enviroment variable
[ ! -z "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"

# Set the state directory enviroment variable
[ ! -z "$XDG_STATE_HOME" ] || export XDG_STATE_HOME="$HOME/.local/state"

##################################################################################

EDITOR=$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null)
VISUAL=$EDITOR

# Manually follow steps from https://steamcommunity.com/app/646570/discussions/1/3935537639868400686
# To disable ~/.oracle_jre_usage/ from being created

# Source aliases
[ ! -f "$XDG_CONFIG_HOME/shell/aliases" ] || source "$XDG_CONFIG_HOME/shell/aliases"
[ ! -f "$XDG_CONFIG_HOME/shell/aliases_personal" ] || source "$XDG_CONFIG_HOME/shell/aliases_personal"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export LESSHISTFILE="$XDG_STATE_HOME/shell/lesshst"
export WGET_HSTS_FILE="$XDG_STATE_HOME/shell/wget-hsts-history" # wget aliased to use this path

# Setup Python
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
command -v pyenv >/dev/null && export PATH="$PATH:$PYENV_ROOT/bin"
command -v pyenv >/dev/null && eval "$(pyenv init -)"
export PYTHON_HISTORY="$XDG_STATE_HOME/shell/python_history" # will be picked up by Python 3.13+
