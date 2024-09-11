#!/usr/bin/env sh

# TODO:
#   - Needs manual installation: appimagelauncher, firefox, brave, vs-code, cursor, kitty, mattermost-desktop, skypedesktop, ulauncher, dotnet8, dotnet8-sdk8.0, aspnetcore-runtime-8.0, Jetbrains Toolbox, Obsidian, Postman, firefox, zen, zoho, zoho-workdrive, nala
#   - Available on some, not on others; may need manual installation: libreoffice, sublime-text, kitty-terminfo, imagemagick

main() {
    ./install-os-packages.sh
    ./install-brew-packages.sh
}

main "$@"
