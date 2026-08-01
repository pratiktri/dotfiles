#!/usr/bin/env sh

PNPM_PACKAGE_FILE=package-list-pnpm

validate_input() {
    if [ ! -f "$PNPM_PACKAGE_FILE" ]; then
        echo "File not found: $PNPM_PACKAGE_FILE"
        exit 1
    fi

    if ! command -v pnpm >/dev/null 2>&1; then
        echo "pnpm not installed"
        exit 2
    fi
}

install_pnpm_packages() {
    missing_packages=""
    found_packages=""

    # Read the package names from the file
    while IFS= read -r pnpm_packages; do
        # Skip lines that start with #
        case "$pnpm_packages" in
        \#*) continue ;;
        esac

        # Check if the package exists in the pnpm repository
        if npm info "$pnpm_packages" >/dev/null 2>&1; then
            echo "Available: $pnpm_packages"
            found_packages="$found_packages $pnpm_packages"
        else
            missing_packages="$missing_packages $pnpm_packages"
            echo "Unavailable: $pnpm_packages"
        fi
    done <"$PNPM_PACKAGE_FILE"

    echo
    echo "Installing available pnpm packages..."
    # shellcheck disable=SC2086
    if ! pnpm install -g $found_packages; then
        exit 1
    fi
}

print_summary() {
    if [ -n "$2" ]; then
        echo
        echo "The following $1 packages were not found in npm repository:"
        echo "$2"
    fi
}

main() {
    # Refuse to run as root (npm/node installs don't need root)
    if [ "$(id -u)" -eq 0 ]; then
        echo "This script should not be run as root. Run it as your normal user."
        return 1
    fi

    validate_input
    install_pnpm_packages
    print_summary "pnpm" "$missing_packages"
}

main "$@"
