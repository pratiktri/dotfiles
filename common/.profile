#!/bin/sh

[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ] || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ ! -f "/opt/homebrew/bin/brew" ] || eval "$(/opt/homebrew/bin/brew shellenv)"

# set PATH so it includes user's private bin if it exists
[ ! -d "$HOME/bin" ] || PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
# HACK: Appended to end of $PATH instead of beginning
# Kitty can't seem to locate nvim when .local/bin is path-ed earlier
# With this, Kitty finds the unstable nvim from ~/.local/bin (for scroll_back buffer selection)
# And I use the brew version of nvim for my work
[ ! -d "$HOME/.local/bin" ] || PATH="$PATH:$HOME/.local/bin"

# Set the config directory environment variable
[ "$XDG_CONFIG_HOME" != "" ] || export XDG_CONFIG_HOME="$HOME/.config"

# Set the cache directory environment variable
[ "$XDG_CACHE_HOME" != "" ] || export XDG_CACHE_HOME="$HOME/.cache"

# Set the data directory environment variable
[ "$XDG_DATA_HOME" != "" ] || export XDG_DATA_HOME="$HOME/.local/share"

# Set the state directory environment variable
[ "$XDG_STATE_HOME" != "" ] || export XDG_STATE_HOME="$HOME/.local/state"

##################################################################################

eval "$(ssh-agent -s)" >/dev/null
# shellcheck disable=SC3045
ulimit -n 10240

[ ! -f "${XDG_CONFIG_HOME}/templates/.gitignore" ] || export GITIGNORE_TEMPLATE="${XDG_CONFIG_HOME}/templates/.gitignore"
[ ! -f "${XDG_CONFIG_HOME}/templates/.prettierrc" ] || export PRETTIER_TEMPLATE="${XDG_CONFIG_HOME}/templates/.prettierrc"
[ ! -f "${XDG_CONFIG_HOME}/templates/.prettierignore" ] || export PRETTIER_IGNORE_TEMPLATE="${XDG_CONFIG_HOME}/templates/.prettierignore"

EDITOR=$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null)
export EDITOR
export VISUAL="$EDITOR"

# Manually follow steps from https://steamcommunity.com/app/646570/discussions/1/3935537639868400686
# To disable ~/.oracle_jre_usage/ from being created

if [ "$(uname -s)" = "Linux" ]; then
    export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME}/nvidia"

    # Needs upstream fix to work: https://bugs.kde.org/show_bug.cgi?id=415770
    export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc":"${XDG_CONFIG_HOME}/gtk-2.0/gtkrc.mine"
    export CUDA_CACHE_PATH="XDG_CACHE_HOME/nv"
fi

export QT_PLUGIN_PATH="$HOME/local/lib/qt/plugins/:"

if [ "$XDG_SESSION_DESKTOP" = "KDE" ]; then
    export KDEHOME="${XDG_CONFIG_HOME}/KDE"
fi

# Homebrew
export HOMEBREW_BAT=1
export HOMEBREW_VEBOSE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=3600
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=30

export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export LESSHISTFILE="${XDG_STATE_HOME}/shell/lesshst"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
[ ! -f "$WGETRC" ] && touch "$WGETRC"

# Setup Python
export PYTHON_HISTORY="${XDG_STATE_HOME}/shell/python_history" # will be picked up by Python 3.13+
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
command -v pyenv >/dev/null && export PATH="$PATH:$PYENV_ROOT/bin:$PYENV_ROOT/shims"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# Setup Rust
export CARGO_HOME="${XDG_DATA_HOME}/rust/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rust/rustup"
export PATH="$PATH:$CARGO_HOME/bin"
export RUSTC_WRAPPER=sccache
export SCCACHE_CACHE_SIZE="20G"

# Setup DotNet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_CLI_HOME="${XDG_CONFIG_HOME}/dotnet"
export DOTNET_TOOLS_PATH="${XDG_DATA_HOME}/dotnet"
export NUGET_PACKAGES="${XDG_CACHE_HOME}/NuGetPackages"
export OMNISHARPHOME="${XDG_CONFIG_HOME}/omnisharp"

# Postgres
export PSQLRC="${XDG_CONFIG_HOME}/postgres/psqlrc"
export PGPASSFILE="${XDG_CONFIG_HOME}/postgres/pgpass"
export PGSERVICEFILE="${XDG_CONFIG_HOME}/postgres/pg_service.conf"
export PSQL_HISTORY="${XDG_STATE_HOME}/psql_history"

# Go
export GOPATH=/media/pratik/Projects/DevSetUps/gopath/

# FIX: BELOW DID NOT WORK: added to /etc/profile, need to recheck on reboot
# alias code="code --extensions-dir ${XDG_DATA_HOME}/vscode"

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"

# Setup Node & n
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/node/npmrc"
export NODE_REPL_HISTORY="${XDG_CONFIG_HOME}/node/node_repl_history"
export N_PREFIX="${XDG_DATA_HOME}/n_node"
export PATH="$N_PREFIX/bin:$PATH"

export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"

export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTS='--layout=reverse --cycle --inline-info --height=~50% --border'

export TLDR_CACHE_DIR="${XDG_CACHE_HOME}/tldr"

export OLLAMA_HOME="${XDG_CONFIG_HOME}/ollama"
