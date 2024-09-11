#!/bin/sh

INSTALL="n"
DRY_RUN="n"

show_help() {
    echo "Apply all settings stored in the script's directory to your home directory"
    echo
    echo "usage: $0 [option]"
    echo "options:"
    echo "  -h, --help      show this help message"
    echo "  -d, --dry-run   Simulate dotfile linking without doing anything"
    echo "  -i, --install   Install programs listed on package-list-os & package-list-brew files"
}

place_dotfile_at_target_location() {
    source_file_location="$1"
    file_target_location="$2"
    TS="$3"

    # To avoid over writing an existing dot-file, we rename them
    # Appending the timestamp to file name
    if [ -f "$file_target_location" ] || [ -L "$file_target_location" ]; then
        [ "$DRY_RUN" = "y" ] && echo "mv ${file_target_location} ${file_target_location}_${TS}" && echo "Existing dotfile renamed to ${file_target_location}_${TS}"
        [ "$DRY_RUN" = "n" ] && mv "$file_target_location" "${file_target_location}_${TS}" && echo "Existing setting renamed to ${file_target_location}_${TS}"
    fi

    target_directory=$(dirname "$file_target_location")
    if [ ! -d "$target_directory" ]; then
        mkdir -p "$target_directory" && echo "Directory ${target_directory} created"
    fi

    [ "$DRY_RUN" = "y" ] && echo "ln -sf ${source_file_location} ${target_directory}"
    [ "$DRY_RUN" = "n" ] && ln -sf "$source_file_location" "$target_directory" && echo "Linked ${file_target_location}"
}

parse_input() {
    # TODO: Accept input to execute install.sh script

    while [ "${#}" -gt 0 ]; do
        case $1 in
        -i | --install)
            INSTALL="y"
            shift
            ;;
        -d | --dry-run)
            DRY_RUN="y"
            shift
            ;;
        -h | --help)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
        esac
    done
}

setup_symlinks() {
    case $(uname -a) in
    Linux*)
        # TODO: Make it less KDE-Neon specific and more general Linux
        OS="kde-neon"

        [ "$XDG_CURRENT_DESKTOP" = "KDE" ] && OS="kde-neon"
        ;;
    Darwin*)
        OS="macos"
        ;;
    *)
        OS="UNSUPPORTED"
        ;;
    esac

    TS=$(date '+%d_%m_%Y-%H_%M_%S')

    # Switch inside dotfile repository directory
    cd -P "$(dirname "$0")" || exit

    # Copy all files in "Common" dotfiles to $HOME directory ("~")
    find "./common" -type f -not -path '*.DS_Store' -not -path '*.directory' | while read -r file; do
        file_target_location="${HOME}${file#./common}"
        source_file_location="${PWD}${file#.}"
        place_dotfile_at_target_location "$source_file_location" "$file_target_location" "$TS"
    done

    # Copy platform-specific files to $HOME directory ("~")
    find "./${OS}" -type f -not -path '*.DS_Store' -not -path '*.directory' | while read -r file; do
        file_target_location="${HOME}${file#./"${OS}"}"
        source_file_location="${PWD}${file#.}"
        place_dotfile_at_target_location "$source_file_location" "$file_target_location" "$TS"
    done
}

main() {
    parse_input "$@"

    install_file_location="$(
        cd -- "$(dirname "$0")" > /dev/null 2>&1 || exit
        pwd -P
    )/scripts"

    setup_symlinks
    echo "$install_file_location"

    if [ "$INSTALL" = "y" ]; then
        cd "$install_file_location" || exit
        [ "$DRY_RUN" = "n" ] && "$install_file_location"/install.sh
    fi
}

main "$@"
