#!/usr/bin/env sh

OS_PACKAGE_FILE=package-list-os

OS_INSTALL_COMMAND=""
OS_PKG_CHECK_COMMAND=""

os_check() {
    # TODO: Apply pre-processing to each.
    #   - Install apt specific things: apt-transport-https, sudo apt-get update && sudo apt-get upgrade -y
    #   - Improve dnf download speed by pre-applying required config
    # Detect package manager and set package manager commands
    if command -v apt-get > /dev/null 2>&1; then
        OS_INSTALL_COMMAND="apt-get update && sudo apt-get upgrade -y && sudo apt-get"
        OS_PKG_CHECK_COMMAND="apt-cache show"
    elif command -v yum > /dev/null 2>&1; then
        OS_INSTALL_COMMAND="yum"
        OS_PKG_CHECK_COMMAND="yum list available"
    elif command -v dnf > /dev/null 2>&1; then
        OS_INSTALL_COMMAND="dnf"
        OS_PKG_CHECK_COMMAND="dnf list available"
    else
        log "Unsupported package manager. This script supports apt, yum, and dnf."
        exit 1
    fi
}

input_file_check() {
    if [ ! -f "$OS_PACKAGE_FILE" ]; then
        echo "File not found: $OS_PACKAGE_FILE"
        exit 1
    fi
}

# Install packages listed on "os-package-list" file
install_os_packages() {
    os_not_found_packages=""
    os_found_packages=""

    echo "Checking package availability..."

    # Loop through each package name in the file
    while IFS= read -r os_package; do
        # Skip lines that start with #
        case "$os_package" in
        \#*) continue ;;
        esac

        # Check if the package exists in the APT repository
        if eval "$OS_PKG_CHECK_COMMAND" "$os_package" > /dev/null 2>&1; then
            echo "Available: $os_package"
            os_found_packages="$os_found_packages $os_package"
        else
            echo "Unavailable: $os_package"
            os_not_found_packages="$os_not_found_packages $os_package"
        fi
    done < "$OS_PACKAGE_FILE"

    eval sudo "$OS_INSTALL_COMMAND" install -y "$os_found_packages"
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
    os_check
    input_file_check
    install_os_packages
    print_summary "OS" "$os_not_found_packages"
}

main "$@"
