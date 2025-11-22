#!/usr/bin/env sh

NODE_PACKAGE_FILE=package-list-node

validate_input() {
    if [ ! -f "$NODE_PACKAGE_FILE" ]; then
        echo "File not found: $NODE_PACKAGE_FILE"
        exit 1
    fi

    if ! command -v node >/dev/null 2>&1; then
        echo "node not installed"
        exit 2
    fi
}

install_node_packages() {
    missing_packages=""
    found_packages=""

    # Read the package names from the file
    while IFS= read -r node_package; do
        # Skip lines that start with #
        case "$node_package" in
        \#*) continue ;;
        esac

        # Check if the package exists in the node repository
        if npm info "$node_package" >/dev/null 2>&1; then
            echo "Available: $node_package"
            found_packages="$found_packages $node_package"
        else
            missing_packages="$missing_packages $node_package"
            echo "Unavailable: $node_package"
        fi
    done <"$NODE_PACKAGE_FILE"

    echo
    echo "Installing available npm packages..."
    # shellcheck disable=SC2086
    if ! npm install -g $found_packages; then
        exit 1
    fi
}

print_summary() {
    if [ -n "$2" ]; then
        echo
        echo "The following $1 packages were not found in npm repository:" | tee -a "$INSTALL_LOG_FILE"
        echo "$2" | tee -a "$INSTALL_LOG_FILE"
    fi
}

main() {
    validate_input
    install_node_packages
    print_summary "node" "$missing_packages"
}

main "$@"
