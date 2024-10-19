# @GNRSN dotfiles

## 🚧 WIP: Setup

- Prerequisite: Install homebrew

- Clone this repo to `~/dotfiles` (note: This path is expected)

- Install nix (multi user installation) through the determinate systems nix installer

- Bootstrap nix-darwin, see documentation, something like
  `nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin#GNRSN/MacBook`

- Bootstrap home-manager, see documentation, something like
  `nix run home-manager -- switch --flake ~/dotfiles/nix-darwin#GNRSN`

- Symlink dotfiles into .config using
  `cd ~/dotfiles && stow .`

## Docs

### Nix

Nix is a build tool/package manager with its own language (DSL) and package repository nixpkgs.
The installer created by determinate systems also allows easy uninstallation so we prefer this over the official installation script

### Nix Darwin

Acts as a glue between Nix and MacOS, allows declarative MacOS configuration inspired by NixOS. Manages itself after bootstrapping.

### Nix Home manager

Installs and configures the user environment. Can "manage" supported software, e.g. managing zsh results in a generated zshrc and so forth.
Enabled per supported software package and then takes ownership for the configuration of that software.

### GNU Stow

Symlink utility, I use this for configs since I want them to be editable with instant refresh. Having to home-manager switch for each config is wasteful friction IMO. Could possibly be replaced with Nix `mkOutOfStoreSymlink`

See discussion in `https://github.com/omerxx/dotfiles/issues/10`

### Rust

Requires to be installed for dependencies that compile from source.
Rustup manages the rust entire rust toolchain, installing versioned cargo through nix seemed overkill for now.
This approach requires installing the toolchain manually through: `rustup default stable`
