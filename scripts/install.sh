#!/usr/bin/env sh

# TODO:
#   - brave, vs-code, cursor, kitty, libreoffice, mattermost-desktop, skypedesktop, ulauncher, code, dotnet8, dotnet8-sdk8.0, aspnetcore-runtime-8.0, sublime-text, AppImage Launcher Settings, Jetbrains Toolbox, Obsidian, Postman, firefox, zen, zoho, zoho-workdrive
#   - `tee` logs to a file
#   - README.md
#   - Integrate with `bootstrap.sh`

# Install packages listed on "os-package-list" file
install_os_packages() {
    # Ignore lines that start with #
    OS_PACKAGES=$(sed "/^#/d" os-package-list | tr "\n\r" " ")
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install $OS_PACKAGES -y
}

# Install packages listed on "brew-package-list" file
install_brew_packages() {
    yes | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Required for installing fonts
    brew tap homebrew/linux-fonts

    # Ignore lines that start with #
    BREW_PACKAGES=$(sed "/^#/d" brew-package-list | tr "\n\r" " ")
    brew install $BREW_PACKAGES
}

main() {
    install_os_packages
    install_brew_packages
}

main "$@"
