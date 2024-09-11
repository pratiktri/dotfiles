#!/usr/bin/env sh

BREW_PACKAGE_FILE=package-list-brew

input_file_check() {
    if [ ! -f "$BREW_PACKAGE_FILE" ]; then
        echo "File not found: $BREW_PACKAGE_FILE"
        exit 1
    fi
}

install_brew() {
    yes | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Required for installing fonts
    brew tap homebrew/linux-fonts
}

# Install packages listed on "brew-package-list" file
install_brew_packages() {
    not_found_packages=""
    found_packages=""

    # Read the package names from the file
    while IFS= read -r brew_package; do
        # Skip lines that start with #
        case "$brew_package" in
        \#*) continue ;;
        esac

        # Check if the package exists in the Homebrew repository
        if brew search "$brew_package" | grep -q "^$brew_package\$"; then
            echo "Available: $brew_package"
            found_packages="$found_packages $brew_package"
        else
            not_found_packages="$not_found_packages $brew_package"
            echo "Unavailable: $brew_package"
        fi
    done < "$BREW_PACKAGE_FILE"

    brew install $found_packages
}

print_summary() {
    # Print the list of packages that were not found
    echo
    if [ -n "$2" ]; then
        echo "The following $1 packages were not found in the repository:"
        echo "$2"
    fi
}

main() {
    input_file_check
    install_brew
    install_brew_packages
    print_summary "Brew" "$not_found_packages"
}

main "$@"
