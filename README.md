# Dotfiles

1. Restore my dotfiles on any *nix OS.
2. Install required applications on any Linux OS.

Dotfiles are symlinked from the repo to the required location.
That is, changes on repository get auto reflected on the system.

## Usage

```bash
$ git clone https://github.com/pratiktri/dotfiles

$ bash setup.sh -h
Apply all settings stored in the script's directory to your home directory.

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

`install.sh` calls `install-os-packages.sh` and `install-brew-packages.sh`. Both can be executed separately.

## Test

1. Need to be inside this directory

    ```bash
    cd scripts/test
    ```

2. Change `Dockerfile` as required

3. Run the script

    ```bash
    ./run-test.sh
    ```
