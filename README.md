# Dotfiles

1. Restore my dotfiles on any *nix OS.
2. Install required applications on any Linux OS.

Dotfiles are symlinked from the repo to the required location. Changes made in the repository will be automatically reflected on the system when the symlink is created.

## Usage

```bash
$ git clone https://github.com/pratiktri/dotfiles

$ sh setup.sh -h
Apply all settings stored in the scripts directory to your home directory.

Usage: ./setup.sh [OPTION]
Options:
  -h, --help      Show this help message.
  -d, --dry-run   Simulate dotfile symlink without doing anything.
  -i, --install   Install programs listed on package-list-os & package-list-brew files.
```

## Installation

Installation scripts are inside `scripts` directory.

It reads 2 text files to gather lists of software to install:

1. `package-list-os` - To install using OS package manager.
2. `package-list-brew` - To install using brew package manager.

Any package not available are *skipped*.

`install.sh` calls `install-os-packages.sh` and `install-brew-packages.sh`. But, both can be executed independently.

### Manual installation to be done for various distros

- aka, pending installations that I gave up automating.

- All Distros:
    - Appimagelauncher: <https://github.com/TheAssassin/AppImageLauncher/releases>
    - Zoho Mail: <https://downloads.zohocdn.com/zmail-desktop/linux/>
    - Zoho Workdrive: <https://www.zoho.com/workdrive/desktop-sync.html>
- Debian & Ubuntu:
    - Add non-free and backport sources, then run the `install-os-packges.sh` again
    - Ulauncher: <https://ulauncher.io/#Download>

## Test

1. Need to be inside this directory

    ```bash
    cd scripts/test
    ```

2. Use `Dockerfile` to change OS

3. Run the script

    ```bash
    ./run-test.sh
    ```
