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
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    # Non-interactive mode can't ask for the sudo password, so cache it first
    sudo -v || return 1
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    for brew_bin in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$brew_bin" ]; then
            eval "$("$brew_bin" shellenv)"
            break
        fi
    done

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew installation failed"
        return 1
    fi
}

# Install packages listed on "brew-package-list" file
install_brew_packages() {
    not_found_packages=""
    found_packages=""

    all_formulae=$(brew formulae)
    installed_formulae=$(brew list --formula -1)

    # Read the package names from the file
    while IFS= read -r app_name; do
        # Skip blank lines and lines that start with #
        case "$app_name" in
        '' | \#*) continue ;;
        esac

        # Skip packages installed by brew or already on PATH from the OS
        if grep -qxF "$app_name" <<<"$installed_formulae" || command -v "$app_name" >/dev/null 2>&1; then
            echo "Already installed: $app_name"
        elif grep -qxF "$app_name" <<<"$all_formulae"; then
            echo "Available: $app_name"
            found_packages="$found_packages $app_name"
        else
            not_found_packages="$not_found_packages $app_name"
            echo "Unavailable: $app_name"
        fi
    done <"$BREW_PACKAGE_FILE"

    if [ -z "$found_packages" ]; then
        echo
        echo "Nothing to install"
        return
    fi

    echo
    echo "Installing brew packages..."

    # shellcheck disable=SC2086
    brew install $found_packages
}

print_summary() {
    # Print the list of packages that were not found
    if [ -n "$2" ]; then
        echo
        echo "The following $1 packages were not found in the repository:"
        echo "$2"
    fi
}

main() {
    # Refuse to run as root (brew installs don't need root)
    if [ "$(id -u)" -eq 0 ]; then
        echo "This script should not be run as root. Run it as your normal user."
        return 1
    fi

    input_file_check
    install_brew || return 1

    install_brew_packages
    status=$?
    print_summary "Brew" "$not_found_packages"
    return "$status"
}

main "$@"
