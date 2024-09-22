#!/usr/bin/env sh

# TODO: Things that did not work
#   - Shortcuts: Maximize current window with [Windows + space] didn't
#   - NEOVIM: Lazy did not download automatically
#   - dotfiles: could NOT link it to aliases_personal

# NOTE: should download dotfiles repo to ~ and NOT to ~/Downloads - since we are going to link Downloads

kitty_term() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    mkdir -p ~/.local/bin && ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    mkdir -p ~/.local/share/applications && cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
}

rustlang() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

manual_installs() {
    kitty_term
    rustlang
}

post_install() {
    chsh -s "$(which zsh)" && echo "Default shell changed to zsh"

    # Time fix for Windows dual boot
    timedatectl set-local-rtc 1 --adjust-system-clock && echo "Set Datetime"

    # Use brew-installed fonts current user
    if [ -d /home/linuxbrew/.linuxbrew/share/fonts ]; then
        mkdir -p ~/.local/share/fonts
        ln -s /home/linuxbrew/.linuxbrew/share/fonts/* ~/.local/share/fonts/ && fc-cache -fv
    fi

    rm -rf ~/.cache

    up
    zsh
    nvim
}

pre_install() {
    export INSTALL_LOG_FILE="$(basename "$0")_$(date +"%Y%m%d_%H%M%S")_log.txt"
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
    ./install-brew-packages.sh
    ./install-flatpak-packages.sh

    manual_installs
    post_install

    cat "$INSTALL_LOG_FILE"
}

main "$@"
