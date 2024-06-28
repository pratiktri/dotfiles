#!/bin/sh

# TODO: Use this to better manage dotfiles
# https://github.com/dylanirlbeck/dotfiles/blob/master/scripts/bootstrap.sh

##################################
# Parse script arguments
##################################

# defaults
QUIET="n"
CREATE_LINKS="n"

usage() {
    if   [ "$1" != "" ]; then
        echo     ""
        echo     -e "${CRED}$1${CEND}\n"
    fi

    echo   "Applies all settings stored in the script's directory to your home directory"
    echo   ""
    echo   "Usage: $0 [-q|--quiet] [-l|--create-links]"
    echo   "  -q,     --quiet              No screen outputs"
    echo   "  -l,     --create-links       Creates soft-links to files in the current directory instead of copying them"

    echo   ""
    echo   "Example: $0 -q --create-links"
}

place_dotfile_at_target_location() {
    source_file_location="$1"
    file_target_location="$2"
    TS="$3"

    # echo "${source_file_location}"
    # echo "${file_target_location}"

    # To avoid over writing existing dot file, we rename them
    # Appending the timestamp to file name
    if [ -f "$file_target_location" ] || [ -L "$file_target_location" ]; then
        # echo "mv ${file_target_location} ${file_target_location}_${TS}" && [[ "$QUIET" == "n" ]] && echo "Existing dotfile renamed to ${file_target_location}_${TS}"
        mv "$file_target_location" "${file_target_location}_${TS}" && [ "$QUIET" = "n" ] && echo "Existing setting renamed to ${file_target_location}_${TS}"
    fi

    target_directory
    target_directory=$(dirname "$file_target_location")
    if [ ! -d "$target_directory" ]; then
        mkdir -p "$target_directory" && [ "$QUIET" = "n" ] && echo "Directory ${target_directory} created"
    fi

   if [ "$CREATE_LINKS" = "y" ]; then
        # echo "ln -s ${source_file_location} ${target_directory}"
        ln -s "$source_file_location" "$target_directory" && [ "$QUIET" = "n" ] && echo "Linked ${file_target_location}"
    else
        # echo "cp ${source_file_location} ${target_directory}"
        cp "$source_file_location" "$target_directory"  && [ "$QUIET" = "n" ] && echo "Copied ${file_target_location}"
    fi
}

main()  {
    while [ "${#}" -gt 0 ]; do
        case $1 in
            -q |   --quiet)
                QUIET="y"
                shift
                ;;
            -l |   --create-links)
                CREATE_LINKS="y"
                shift
                ;;
            -h |   --help)
                echo
                usage
                echo
                exit       0
                ;;
            *)
                usage       "Unknown parameter passed: $1" "h"
                exit       1
                ;;
        esac
    done

    case $(uname -a) in
        Linux*)
            OS="linux"
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
    find "./common" -type f -not -path '*.DS_Store' -not -path '*.directory' | while read -r file;
    do
        file_target_location="${file/.\/common/$HOME}"
        source_file_location="${file/./$PWD}"
        place_dotfile_at_target_location "$source_file_location" "$file_target_location" "$TS"
    done

    # Copy platform specific files to $HOME directory ("~")
    find "./${OS}" -type f -not -path '*.DS_Store' -not -path '*.directory' | while read -r file;
    do
        file_target_location="${file/.\/${OS}/$HOME}"
        source_file_location="${file/./$PWD}"
        place_dotfile_at_target_location "$source_file_location" "$file_target_location" "$TS"
    done
}

main "$@"
