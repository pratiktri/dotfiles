#!/usr/bin/env sh

OS_PACKAGE_FILE=package-list-os

setup() {
    OS_INSTALL_COMMAND=""
    OS_PKG_CHECK_COMMAND=""

    # Detect package manager and set package manager commands
    if command -v apt-get > /dev/null 2>&1; then
        OS_INSTALL_COMMAND="apt-get install -y"
        OS_PKG_CHECK_COMMAND="apt-cache show"

        apt_setup
    elif command -v dnf > /dev/null 2>&1; then
        OS_INSTALL_COMMAND="dnf install -y --allowerasing --skip-broken"
        OS_PKG_CHECK_COMMAND="dnf list available"

        dnf_setup
    else
        log "Unsupported package manager. This script supports apt, yum, and dnf."
        exit 1
    fi
}

dnf_setup() {
    # Faster dnf installs
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
    echo "defaultYes=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
    echo "keepcache=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null

    # Enable RPM Fusion & Install media codecs
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm && sudo dnf groupupdate -y core multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin sound-and-video
}

apt_setup() {
    sudo apt-get update && sudo apt-get upgrade -y
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
        if eval "$OS_PKG_CHECK_COMMAND" "$os_package" 2> /dev/null | grep -q "$os_package"; then
            echo "Available: $os_package"
            os_found_packages="$os_found_packages $os_package"
        else
            echo "Unavailable: $os_package"
            os_not_found_packages="$os_not_found_packages $os_package"
        fi
    done < "$OS_PACKAGE_FILE"

    # Install available packages
    if ! eval sudo "$OS_INSTALL_COMMAND" "$os_found_packages"; then
        exit 1
    fi
}

print_summary() {
    # Print the list of packages that were not found
    if [ -n "$2" ]; then
        echo | tee -a "$INSTALL_LOG_FILE"
        echo "The following $1 packages were not found in the repository:" | tee -a "$INSTALL_LOG_FILE"
        echo "$2" | tee -a "$INSTALL_LOG_FILE"
    fi
}

main() {
    input_file_check
    setup
    install_os_packages
    print_summary "OS" "$os_not_found_packages"
}

main "$@"
