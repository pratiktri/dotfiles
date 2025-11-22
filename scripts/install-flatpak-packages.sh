#!/usr/bin/env sh

FLATPAK_PACKAGE_FILE=package-list-flatpak

input_file_check() {
    if [ ! -f "$FLATPAK_PACKAGE_FILE" ]; then
        echo "File not found: $FLATPAK_PACKAGE_FILE"
        exit 1
    fi
}

setup_flatpak() {
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && echo "Flathub added to Flatpak"
}

# Install packages listed on "flatpak-package-list" file
install_flatpak_packages() {
    not_found_packages=""
    found_packages=""

    # Read the package names from the file
    while IFS= read -r flatpak_package; do
        # Skip lines that start with #
        case "$flatpak_package" in
        \#*) continue ;;
        esac

        # Check if the package exists in the flatpak repository
        if flatpak search --columns=application "$flatpak_package" 2>/dev/null | grep -q "^$flatpak_package\$"; then
            echo "Available: $flatpak_package"
            found_packages="$found_packages $flatpak_package"
        else
            not_found_packages="$not_found_packages $flatpak_package"
            echo "Unavailable: $flatpak_package"
        fi
    done <"$FLATPAK_PACKAGE_FILE"

    echo
    echo "Installing available flatpak packages..."
    # shellcheck disable=SC2086
    if ! flatpak install -y --noninteractive $found_packages; then
        exit 1
    fi
}

print_summary() {
    # Print the list of packages that were not found
    if [ -n "$2" ]; then
        echo
        echo "The following $1 packages were not found in the repository:" | tee -a "$INSTALL_LOG_FILE"
        echo "$2" | tee -a "$INSTALL_LOG_FILE"
    fi
}

main() {
    input_file_check
    setup_flatpak
    install_flatpak_packages
    print_summary "flatpak" "$not_found_packages"
}

main "$@"
