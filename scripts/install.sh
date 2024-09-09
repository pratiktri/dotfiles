#!/usr/bin/env sh

# TODO:
#    - Display log or show instruction to see the logs
#    - Add logs to a file
#    - How to manage/recover from installation issues

# TODO: ppa: brave, vs-code, cursor, kitty, libreoffice, mattermost-desktop, skypedesktop, ulauncher, code, dotnet8, dotnet8-sdk8.0, aspnetcore-runtime-8.0, sublime-text, AppImage Launcher Settings, Jetbrains Toolbox, Obsidian, Postman, firefox, zen, zoho, zoho-workdrive

install_os_packages() {
    # Install packages listed on "os-package-list" file
    # Ignore lines that start with #
    OS_PACKAGES=$(sed "/^#/d" os-package-list | tr "\n\r" " ")
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install $OS_PACKAGES -y
}

install_brew_packages() {
    # Install packages listed on "brew-package-list" file
    # Ignore lines that start with #
    yes | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME"/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew tap homebrew/linux-fonts # Required for nerd fonts
    BREW_PACKAGES=$(sed "/^#/d" brew-package-list | tr "\n\r" " ")
    brew install $BREW_PACKAGES
}

main() {
    install_os_packages
#    install_brew_packages
}

main "$@"
