#!/usr/bin/env sh

# TODO:
#   - Update `bootstrap-dotfiles.sh` to work from its parent directory & ignore "scripts" directory
#   - Integrate with `bootstrap-dotfiles.sh` -> do dotfiles 1st, then install
#   - README.md
#   - Needs manual installation: appimagelauncher, firefox, brave, vs-code, cursor, kitty, mattermost-desktop, skypedesktop, ulauncher, dotnet8, dotnet8-sdk8.0, aspnetcore-runtime-8.0, Jetbrains Toolbox, Obsidian, Postman, firefox, zen, zoho, zoho-workdrive, nala
#   - Available on some, not on others; may need manual installation: libreoffice, sublime-text, kitty-terminfo

main() {
    ./install-os-packages.sh
    ./install-brew-packages.sh
}

main "$@"
