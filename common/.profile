#!/bin/sh

[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ] || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ ! -f "/opt/homebrew/bin/brew" ] || eval "$(/opt/homebrew/bin/brew shellenv)"

# set PATH so it includes user's private bin if it exists
# HACK: Appended to end of $PATH instead of beginning
# Kitty can't seem to locate nvim when .local/bin is path-ed earlier
# With this, Kitty finds the unstable nvim from ~/.local/bin (for scroll_back buffer selection)
# And I use the brew version of nvim for my work
[ ! -d "$HOME/.local/bin" ] || PATH="$PATH:$HOME/.local/bin"

[ "$XDG_CONFIG_HOME" != "" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_CACHE_HOME" != "" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_DATA_HOME" != "" ] || export XDG_DATA_HOME="$HOME/.local/share"
[ "$XDG_STATE_HOME" != "" ] || export XDG_STATE_HOME="$HOME/.local/state"

##################################################################################

if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)" >/dev/null
fi

# shellcheck disable=SC3045
ulimit -n 10240

EDITOR=$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null)
export EDITOR
export VISUAL="$EDITOR"

# Following in /etc/environment to fix electron app font issues
# export ELECTRON_OZONE_PLATFORM_HINT=auto

# Manually follow steps from https://steamcommunity.com/app/646570/discussions/1/3935537639868400686
# To disable ~/.oracle_jre_usage/ from being created
if [ "$(uname -s)" = "Linux" ]; then
    export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME}/nvidia"

    # Needs upstream fix to work: https://bugs.kde.org/show_bug.cgi?id=415770
    export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc":"${XDG_CONFIG_HOME}/gtk-2.0/gtkrc.mine"
    export CUDA_CACHE_PATH="XDG_CACHE_HOME/nv"
fi

export QT_PLUGIN_PATH="$HOME/.local/lib/qt/plugins/:"

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

export DEV_CACHE_PATH="/media/${USER}/Projects/DevSetUps"

# Podman's Docker-compatible socket (rootless)
# Makes lazydocker work
# DOCKER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
# export DOCKER_HOST
export PODMAN_COMPOSE_WARNING_LOGS=false

export LIBVIRT_DEFAULT_URI="qemu:///system"

export WGETRC="${XDG_CONFIG_HOME}/wgetrc" && [ ! -f "$WGETRC" ] && touch "$WGETRC"
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export LESSHISTFILE="${XDG_STATE_HOME}/shell/lesshst"
export TLDR_CACHE_DIR="${XDG_CACHE_HOME}/tldr"
export OLLAMA_HOME="${XDG_CONFIG_HOME}/ollama/"
export OLLAMA_MODELS="${DEV_CACHE_PATH}/AI-Models/"
[ ! -f "$HOME/.lmstudio/bin" ] || export PATH="$PATH:$HOME/.lmstudio/bin"

export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTS='--layout=reverse --cycle'
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

[ ! -d "${XDG_CONFIG_HOME}/templates" ] || export TEMPLATE_DIR="${XDG_CONFIG_HOME}/templates"

# Python
export PYTHON_HISTORY="${XDG_STATE_HOME}/shell/python_history" # will be picked up by Python 3.13+
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
command -v pyenv >/dev/null && export PATH="$PATH:$PYENV_ROOT/bin:$PYENV_ROOT/shims"
command -v pyenv >/dev/null && eval "$(pyenv init -)"
export PATH="$XDG_DATA_HOME/python/bin:$PATH"

# Rust
export CARGO_HOME="${XDG_DATA_HOME}/rust/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rust/rustup"
# shellcheck disable=SC1091
[ -f "${CARGO_HOME}/env" ] && . "${CARGO_HOME}/env"
export RUSTC_WRAPPER=sccache
export SCCACHE_CACHE_SIZE="20G"

# DotNet
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
export GOPATH="${DEV_CACHE_PATH}"/gopath/

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"

# Setup Node & n
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/node/npmrc"
export NODE_REPL_HISTORY="${XDG_CONFIG_HOME}/node/node_repl_history"
export N_PREFIX="${XDG_DATA_HOME}/n_node"
export PATH="$N_PREFIX/bin:$PATH"
command -v npm >/dev/null 2>&1 && PATH="$(npm config get prefix)/bin:$PATH"

# Bun configurations
export BUN_INSTALL_GLOBAL_DIR="$(npm config get prefix)/lib"
export BUN_INSTALL_BIN="$(npm config get prefix)/bin"

# CUDA path
export PATH="/usr/local/cuda-13.1/bin:$PATH"
export CUDA_HOME="/usr/local/cuda-13.1/"
export LD_LIBRARY_PATH="/usr/local/cuda-13.1/lib64:$LD_LIBRARY_PATH"
