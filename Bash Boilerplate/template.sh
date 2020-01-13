#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
# SYNOPSIS
#   ${SCRIPT_NAME} [-hv] [-o[file]] args ...
#
# DESCRIPTION
#   This is a script template
#   to start any good shell script.
#   More details at https://github.com/pratiktri/your_project
#
# OPTIONS
#   -o [file], --output=[file]    Set log file (default=/dev/null)
#                                  use DEFAULT keyword to autoname file
#                                  The default value is /dev/null.
#   -t, --timelog                 Add timestamp to log ("+%y/%m/%d@%H:%M:%S")
#   -x, --ignorelock              Ignore if lock file exists
#   -h, --help                    Print this help
#   -v, --version                 Print script information
#
# EXAMPLES
#    ${SCRIPT_NAME} -o DEFAULT arg1 arg2
#
#================================================================
# IMPLEMENTATION
#    version         ${SCRIPT_NAME} (www.uxora.com) 0.0.4
#    author          Your Name Here
#    copyright       Copyright (c) 
#    license         GNU General Public License
#
#================================================================
#  HISTORY
#     2015/03/01 : mvongvilay : Script creation
#     2015/04/01 : mvongvilay : Add long options and improvements
# 
#================================================================
# END OF HEADER
#================================================================

# All pending items here
# TODO
    # Get the logging template
        # Enable/Disable logging
        # Log to STDOUT, File, Syslog - either or all
        # Verbose and quite options
        # Dates should be standard and non-abiguous
        # STDOUT should have bright-yellow to display summary
            # Red to display error
            # Show the log location at the beginning and end
    # Error Handling
        # Traps




#### Bash Strict mode
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Exit on error inside any functions or subshells.
set -o errtrace


# Fail-fast checks
[[ "$(id --user)" != "0" ]] && {
    echo -e "ERROR: You must be root to run this script.\nUse sudo and execute the script again."
}


usage() {
    cat <<USAGE
Usage:
    sudo $0 --project-name <name> --wp-source-dir <path> --backup-dir <path> [--storage-quota <size>] [--passphrase-dir <path>]"
    -pname,         --project-name      A Unique name (usually the website name) for this backup
    -wp_src,        --wp-source-dir     Directory where your WordPress website is stored
    --backup-dir                        Directory where backup files will be stored
    -quota,         --storage-quota     [Optional] Unlimited by default
                                        When supplied backups would never exceed this capacity. 
                                        Older backups will automatically be deleted to make room for new ones.
    -passdir,       --passphrase-dir    [Optional] /home/[user]/.config/borg by default
                                        Backups keys are stored (in plain-text) at this location.
                                        Use "export BORG_PASSPHRASE" as shown in the example below to avoid saving passphrase to file.
    -h,             --help              Display this information

    NOTE:- You MUST specify BORG_PASSPHRASE by export 

    $ export BORG_PASSPHRASE=<your-passphrase>
    $ sudo $0 --project-name "example.com" --wp-source-dir "/var/www/example.com" --backup-dir "/home/me/backup/example.com"  --storage-quota 5G --passphrase-dir /root/borg

USAGE

    # If user asked to display this information - exit normally
    if [[ ! "$#" -eq 0 ]]; then
        exit 0
    fi
}


# Everything should be inside a function
# main() would contain the start of the script
main() {
    # Explicitly Declare all variables as "local"
    local SCRIPT_VERSION
    local SCRIPT_NAME
    readonly SCRIPT_VERSION=1.0, SCRIPT_NAME=wp_borg_backup

    ################################# Parse Script Arguments #################################

    while [[ "${#}" -gt 0 ]]; do
        case $1 in
            --project-name | -pname)

                shift
                shift
                ;;
            -h|--help)
                echo
                usage OK
                echo
                exit 0
                ;;
            *)
                echo
                echo "Unknown parameter encounted : $1 - this will be ignored"
                echo
                shift
                ;;
        esac
    done

    # Check if mandatory items were provided or not
    # if [[ -z "${project_name}" ]]; then
    #     echo "ERROR: Script requires a project name (--project-name | -pname) parameter" 2>STDERR
    #     usage
    #     exit 6
    # fi

    ################################# Parse Script Arguments #################################




    ######################################### Set up  #########################################

    # Set variables that you require for the rest of the operations here
    local TS
    local LOGFILE

    # Create the backup directory structure
    readonly TS="$(date '+%d_%m_%Y-%H_%M_%S')"
    readonly LOGFILE=/tmp/"${SCRIPT_NAME}"_v"${SCRIPT_VERSION}"_"${TS}".log
    touch "${LOGFILE}"
    echo "You can find the log at ${LOGFILE}"

    ######################################### Set up  #########################################



    ################################## Operation 1 ##################################

    # Do your stuff here


    ################################## Operation 1 ##################################
}


# Call the main() here
main "$@"