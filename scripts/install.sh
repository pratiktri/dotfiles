#!/usr/bin/env sh

kitty_term() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    mkdir -p ~/.local/bin && ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    mkdir -p ~/.local/share/applications && cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' >~/.config/xdg-terminals.list
}

rustlang() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

manual_installs() {
    if [ "$(uname -s)" != "FreeBSD" ]; then
        kitty_term
    fi
    rustlang
}

post_install() {
    sudo -u "${SUDO_USER:-$(logname)}" systemctl --user enable --now podman.socket
    command -v docker >/dev/null 2>&1 && systemctl enable --now docker >/dev/null 2>&1 && echo "Docker enabled"
    command -v docker >/dev/null 2>&1 && usermod -aG docker "$USER" && newgrp docker && echo "Added $USER to docker group"

    chsh -s "$(which zsh)" && echo "Default shell changed to zsh"

    # Time fix for Windows dual boot - skip on FreeBSD
    if [ "$(uname -s)" != "FreeBSD" ]; then
        timedatectl set-local-rtc 1 --adjust-system-clock && echo "Set Datetime"
    fi

    rm -rf ~/.cache
}

pre_install() {
    export INSTALL_LOG_FILE
    INSTALL_LOG_FILE="$(basename "$0")_$(date +"%Y%m%d_%H%M%S")_log.txt"
    echo
    echo "Starting Installation..."
    echo "Use the following command to view the list of software that was NOT installed:"
    echo "cat $PWD/$INSTALL_LOG_FILE"
    echo

    if [ -f ~/.profile ]; then
        . ~/.profile
    fi
}

main() {
    pre_install

    ./install-os-packages.sh

    # Skip brew installation on FreeBSD
    if [ "$(uname -s)" != "FreeBSD" ]; then
        ./install-brew-packages.sh
    fi

    manual_installs
    post_install

    cat "$INSTALL_LOG_FILE"
}

main "$@"
