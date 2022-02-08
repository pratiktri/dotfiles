#!/usr/bin/env bash

usage() {
  if   [ -n "$1" ]; then
    echo     ""
    echo     -e "${CRED}$1${CEND}\n"
  fi

  echo   "Applies all settings stored in the script's directory to your home directory"
  echo   ""
  echo   "Usage: $0 [-q|--quiet] [-l|--create-links]"
  echo   "  -q,     --quiet              No screen outputs"
  echo   "  -l,     --create-links       Creates soft-links to files in the current directory instead of copying them"

  echo   ""
  echo   "Example: bash ./$0 -q --create-links"
}

##################################
# Parse script arguments
##################################

# defaults
QUIET="n"
CREATE_LINKS="n"

while [[ "${#}" -gt 0 ]]; do
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

main()  {
  TS=$(date '+%d_%m_%Y-%H_%M_%S')

  # Switch inside dotfile directory
  cd -P "$( dirname "$0")" || exit
  SCRIPT_DIR="$(pwd)"

  find . -type f ! -name "$0" ! -path '*/.idea/*' ! -path '*/.git/*' ! -name 'LICENSE' ! -name 'README.md' -print0 | while IFS= read -r -d '' file; do
    # Replaces `.` with `~` in the found file names
    target_file="${file/./~}"

    if [[ -f "${target_file}" ]]; then
      mv "$target_file" "${target_file}_${TS}" && [[ "$QUIET" == "n" ]] && echo "Existing setting renamed to ${target_file}_${TS}"
    fi

    target_directory=$(dirname "${target_file}")
    if [[ ! -d "${target_directory}" ]]; then
      mkdir -p "${target_directory}" && [[ "$QUIET" == "n" ]] && echo "Directory ${target_directory} created"
    fi

    if [[ "$CREATE_LINKS" == "y" ]]; then
      ln -s "${file/./${SCRIPT_DIR}}" "${target_file}" && [[ "$QUIET" == "n" ]] && echo "Linked ${target_file}"
    else
      cp "${file/./${SCRIPT_DIR}}" "${target_file}"  && [[ "$QUIET" == "n" ]] && echo "Copied ${target_file}"
    fi
  done
}

main "$@"
