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

zed_ide() {
    curl -f https://zed.dev/install.sh | sh /dev/stdin
}

rustlang() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

nerd_fonts() {
    if [ -d "$HOME/.local/share/fonts/nerd-fonts" ]; then
        echo "Nerd Fonts already installed at ~/.local/share/fonts/nerd-fonts"
        return
    fi

    tmpdir="$(mktemp -d)"
    git clone --depth 1 --filter=blob:none --sparse \
        https://github.com/ryanoasis/nerd-fonts.git "$tmpdir/nerd-fonts" 2>/dev/null
    cd "$tmpdir/nerd-fonts" || return
    ./install.sh -q FiraCode JetBrainsMono SourceCodePro
    rm -rf "$tmpdir"
}

manual_installs() {
    if [ "$(uname -s)" != "FreeBSD" ]; then
        kitty_term
        zed_ide
    fi
    nerd_fonts
    rustlang
}

post_install() {
    systemctl --user enable --now podman.socket 2>/dev/null && echo "Podman socket enabled"

    if command -v docker >/dev/null 2>&1; then
        sudo systemctl enable --now docker >/dev/null 2>&1 && echo "Docker enabled"
        sudo usermod -aG docker "$USER" && echo "Added $USER to docker group. Log out and back in for changes to take effect."
    fi

    if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(which zsh)" ]; then
        sudo chsh -s "$(which zsh)" "$USER" && echo "Default shell changed to zsh" || echo "Could not change shell."
    fi

    # Time fix for Windows dual boot - skip on FreeBSD
    if [ "$(uname -s)" != "FreeBSD" ]; then
        sudo timedatectl set-local-rtc 1 --adjust-system-clock && echo "Set Datetime"
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

    sudo ./install-os-packages.sh
    ./install-node-packages.sh

    # Skip flatpak & brew installations on FreeBSD
    if [ "$(uname -s)" != "FreeBSD" ]; then
        # ./install-flatpak-packages.sh
        ./install-brew-packages.sh
    fi

    manual_installs
    post_install

    cat "$INSTALL_LOG_FILE"
}

main "$@"
