#!/usr/bin/env sh

OS_PACKAGE_FILE=package-list-os
OS_INSTALL_COMMAND=""
OS_PKG_CHECK_COMMAND=""

setup() {
    if [ -f /etc/debian_version ] || [ -f /etc/ubuntu_version ]; then
        OS_INSTALL_COMMAND="apt-get install -y"
        OS_PKG_CHECK_COMMAND="apt-cache show"
        apt_setup
    elif [ -f /etc/rocky-release ] || [ -f /etc/almalinux-release ] || [ -f /etc/centos-release ] || [ -f /etc/fedora-release ]; then # Fedora, CentOS, Rocky, Almalinux
        OS_INSTALL_COMMAND="dnf install -y --allowerasing --skip-broken"
        OS_PKG_CHECK_COMMAND="dnf list available"
        dnf_setup
    elif [ -f /etc/freebsd-update.conf ]; then # FreeBSD
        OS_INSTALL_COMMAND="pkg install -y"
        OS_PKG_CHECK_COMMAND="pkg search"
        freebsd_setup
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

freebsd_setup() {
    # Update package repository
    sudo pkg update && sudo pkg upgrade

    # Install KDE WM
    sudo pkg install -y xorg sddm nvidia-driver
    sudo pkg install -y kde5 plasma5-sddm-kcm plasma5-nm

    # Add current user to video & wheel group
    sudo pw groupmod video -m "$(whoami)"
    sudo pw groupmod wheel -m "$(whoami)"

    # Load nvidia drivers to kernel
    sudo sysrc kld_list+="nvidia-modeset nvidia"

    # Enable services that will be needed
    sudo sysrc dbus_enable="YES"
    sudo sysrc sddm_enable="YES"
    sudo service dbus start

    sudo sysctl net.local.stream.recvspace=65535
    sudo sysctl net.local.stream.sendspace=65535

    echo "exec dbus-launch --exit-with-x11 ck-launch-session startplasma-x11" >~/.xinitrc
}

dnf_setup() {
    # Faster dnf installs
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
    echo "defaultYes=True" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
    echo "keepcache=True" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
    echo "minrate=40k" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
    echo "timeout=20" | sudo tee -a /etc/dnf/dnf.conf >/dev/null

    # Enable RPM Fusion & Install media codecs
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm && sudo dnf groupupdate -y core multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin sound-and-video && sudo dnf makecache

    # Add VS-Code repo
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    printf "%s\n%s\n%s\n%s\n%s\n%s\n" "[code]" "name=Visual Studio Code" "baseurl=https://packages.microsoft.com/yumrepos/vscode" "enabled=1" "gpgcheck=1" "gpgkey=https://packages.microsoft/com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

    # Add docker repository
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # Add Brave repository
    sudo dnf-3 config-manager --add-repo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

    # Install development Tools
    sudo yum groupinstall -y "Development Tools" && yum install readline readline-devel -y

    # Download and install appimagelauncher
    wget "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm" -O /tmp/package.rpm && sudo rpm -i /tmp/package.rpm && "Installed AppImageLauncher"

    dnf check-update
}

apt_setup() {
    # Debian/Ubuntu
    [ -f /etc/os-release ] && . /etc/os-release

    sudo apt-get update && sudo apt-get upgrade -y

    sudo apt-get install -y wget gpg extrepo
    sudo extrepo update
    sudo extrepo enable dotnet
    sudo extrepo enable docker-ce
    sudo extrepo enable github-cli
    sudo extrepo enable mattermost
    sudo extrepo enable nvidia-cuda
    sudo extrepo enable postgresql
    sudo extrepo enable vscode
    sudo extrepo enable winehq
    sudo extrepo enable deb-multimedia-backports
    sudo extrepo enable deb-multimedia-non-free
    sudo extrepo enable trivy

    if [ "$ID" = "debian" ]; then
        debian_setup
    else
        ubuntu_setup
    fi

    sudo apt-get update
}

debian_setup() {
    # Add Ulauncher repo
    sudo apt update && sudo apt install -y gnupg
    sudo gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176 && sudo gpg --export 0xfaf1020699503176 | sudo tee /usr/share/keyrings/ulauncher-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/ulauncher-archive-keyring.gpg] \
          http://ppa.launchpad.net/agornostal/ulauncher-dev/ubuntu jammy main" |
        sudo tee /etc/apt/sources.list.d/ulauncher-dev-jammy.list
}

ubuntu_setup() {
    # Add Ulauncher repo
    sudo add-apt-repository universe -y && sudo add-apt-repository ppa:agornostal/ulauncher -y
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
        if eval "$OS_PKG_CHECK_COMMAND" "$os_package" 2>/dev/null | grep -q "$os_package"; then
            echo "Available: $os_package"
            os_found_packages="$os_found_packages $os_package"
        else
            echo "Unavailable: $os_package"
            os_not_found_packages="$os_not_found_packages $os_package"
        fi
    done <"$OS_PACKAGE_FILE"

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
