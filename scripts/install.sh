#!/usr/bin/env sh

# All:
#   - Jetbrains-Toolbox: https://www.jetbrains.com/toolbox-app/
#   - Sublime-Text: https://www.sublimetext.com/docs/linux_repositories.html
#   - Appimagelauncher: https://github.com/TheAssassin/AppImageLauncher/releases
#   - Zoho Mail: https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v1.6.4.AppImage
#   - Zoho Workdrive: https://files-accl.zohopublic.com/public/wdbin/download/2014030a29db316e9cedd501f32270e8
#   - Cursor: https://downloader.cursor.sh/linux/appImage/x64
# Debian & Ubuntu:
#   - Ulauncher: https://ulauncher.io/#Download
# Debian:
#   - Dotnet8: https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install

# Jetbrains: check if scriptfile not available (because we use flatpak) has any issued with ulauncher

kitty_term() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    mkdir -p ~/.local/bin && ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    mkdir -p ~/.local/share/applications && cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
}

manual_installs(){
    kitty_term
}

post_install() {
    chsh -s "$(which zsh)" && echo "Default shell changed to zsh"

    # Time fix for Windows dual boot
    timedatectl set-local-rtc 1 --adjust-system-clock && echo "Set Datetime"

    # Use brew-installed fonts current user
    if [ -d /home/linuxbrew/.linuxbrew/share/fonts ]; then
        ln -s /home/linuxbrew/.linuxbrew/share/fonts -t ~/.local/share && fc-cache -fv
    fi

    rm -rf ~/.cache
}

pre_install() {
    export INSTALL_LOG_FILE="$(basename "$0")_$(date +"%Y%m%d_%H%M%S")_log.txt"
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
