#!/usr/bin/env sh

OS_PACKAGE_FILE=package-list-os
OS_INSTALL_COMMAND=""
OS_PKG_CHECK_COMMAND=""

setup() {
    # Detect OS via /etc/os-release (or /usr/lib/os-release) as primary source.
    if [ -f /etc/os-release ]; then
        . /etc/os-release
    elif [ -f /usr/lib/os-release ]; then
        . /usr/lib/os-release
    fi

    OS_ID="${ID:-}"
    case "$OS_ID" in
    debian | ubuntu | linuxmint | pop | elementary | zorin | kali)
        OS_INSTALL_COMMAND="apt-get install -y"
        OS_PKG_CHECK_COMMAND="apt-cache show"
        apt_setup
        ;;
    fedora | rhel | centos | rocky | almalinux)
        OS_INSTALL_COMMAND="dnf install -y --allowerasing --skip-broken"
        OS_PKG_CHECK_COMMAND="dnf list available"
        dnf_setup
        ;;
    opensuse* | suse)
        OS_INSTALL_COMMAND="zypper install --no-recommends -y"
        OS_PKG_CHECK_COMMAND="zypper search --match-exact"
        zypper_setup
        ;;
    arch | endeavouros | manjaro | arcolinux | garuda)
        OS_INSTALL_COMMAND="pacman -S --noconfirm"
        OS_PKG_CHECK_COMMAND="pacman -Si"
        echo "Unsupported operating system (ID=$OS_ID)"
        return 1
        ;;
    void)
        OS_INSTALL_COMMAND="xbps-install -y"
        OS_PKG_CHECK_COMMAND="xbps-query -R"
        echo "Unsupported operating system (ID=$OS_ID)"
        return 1
        ;;
    alpine)
        OS_INSTALL_COMMAND="apk add"
        OS_PKG_CHECK_COMMAND="apk search -e"
        echo "Unsupported operating system (ID=$OS_ID)"
        return 1
        ;;
    *)
        # Fallback: FreeBSD (no /etc/os-release)
        if [ -f /etc/freebsd-update.conf ]; then
            OS_INSTALL_COMMAND="pkg install -y"
            OS_PKG_CHECK_COMMAND="pkg search"
            freebsd_setup
            return
        fi
        # Fallback: Debian/Ubuntu without /etc/os-release (old chroots, containers)
        if [ -f /etc/debian_version ]; then
            OS_INSTALL_COMMAND="apt-get install -y"
            OS_PKG_CHECK_COMMAND="apt-cache show"
            apt_setup
            return
        fi
        echo "Unsupported operating system (ID=$OS_ID)"
        return 1
        ;;
    esac
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

    # Add docker repository
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Add Brave repository
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

    # Download and install appimagelauncher
    wget -O /tmp/package.rpm "https://github.com/theassassin/appimagelauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm" && sudo dnf install -y /tmp/package.rpm && echo "installed appimagelauncher"

    sudo dnf check-update
}

zypper_setup() {
    # Refresh repos and update system
    sudo zypper --non-interactive refresh && sudo zypper --non-interactive update -y

    # Add Packman repository (essential for multimedia codecs)
    sudo zypper --non-interactive addrepo --refresh --check --priority 90 \
        https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
    sudo zypper dup --from packman --allow-vendor-change

    # Add Brave repository
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

    # Docker is available in default Tumbleweed repos, no extra repo needed

    # Download and install AppImageLauncher v3
    wget -O /tmp/appimagelauncher.rpm \
        "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm"
    sudo zypper install /tmp/appimagelauncher.rpm

    sudo zypper --non-interactive refresh
}

apt_setup() {
    # Debian/Ubuntu
    [ -f /etc/os-release ] && . /etc/os-release

    sudo apt-get update && sudo apt-get upgrade -y

    sudo apt-get install -y wget gpg extrepo
    sudo extrepo update
    sudo extrepo enable docker-ce
    sudo extrepo enable github-cli
    sudo extrepo enable nvidia-cuda
    sudo extrepo enable postgresql
    sudo extrepo enable deb-multimedia-backports
    sudo extrepo enable deb-multimedia-non-free

    sudo apt-get update
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
    setup || return 1
    install_os_packages
    print_summary "OS" "$os_not_found_packages"
}

main "$@"
