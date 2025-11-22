#!/usr/bin/env bash
# NOTE: This is NOT POSIX compliant because - brew install script does not support that

BREW_PACKAGE_FILE=package-list-brew

input_file_check() {
    if [ ! -f "$BREW_PACKAGE_FILE" ]; then
        echo "File not found: $BREW_PACKAGE_FILE"
        exit 1
    fi
}

install_brew() {
    if ! command -v brew >/dev/null 2>&1; then
        yes | NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "Brew install failed"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# Install packages listed on "brew-package-list" file
install_brew_packages() {
    not_found_packages=""
    found_packages=""

    # Read the package names from the file
    while IFS= read -r app_name; do
        # Skip lines that start with #
        case "$app_name" in
        \#*) continue ;;
        esac

        # Check if package exists in brew repository and is not already installed on the system
        if brew info "$app_name" >/dev/null 2>&1; then
            if ! command -v "$app_name" >/dev/null 2>&1; then
                echo "Available: $app_name"
                found_packages="$found_packages $app_name"
            else
                echo "Already installed: $app_name"
            fi
        else
            not_found_packages="$not_found_packages $app_name"
            echo "Unavailable: $app_name"
        fi
    done <"$BREW_PACKAGE_FILE"

    echo
    echo "Installing brew packages..."
    # shellcheck disable=SC2086
    if ! brew install $found_packages; then
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
    install_brew

    install_brew_packages
    print_summary "Brew" "$not_found_packages"
}

main "$@"
