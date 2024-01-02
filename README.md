# dotfiles

Place to keep my .dotfiles so I do not have to worry about migrating to another system.

## Usage

```bash
$ bash bootstrap.sh -h

Applies all settings stored in the script's directory to your home directory

Usage: bootstrap.sh [-q|--quiet] [-l|--create-links]
  -q,     --quiet              No screen outputs
  -l,     --create-links       Creates soft-links to files in the current directory instead of copying them

Example: bash ./bootstrap.sh -q --create-links
```

## Why `--create-links`?

I have multiple Linux installations on my machine. Linking it from one place (this repository) keeps things tidy. Also, changes to dotfiles automatically get applied to all the distros.

<!-- TODO: Move as many dotfiles inside ~/.config as possible -->
