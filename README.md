# @GNRSN dotfiles

## 🚧 WIP: Setup

- Clone this repo to `~/dotfiles` (note: This path is expected)

- Install homebrew

- Install nix (multi user installation) through the determinate systems nix installer

- Bootstrap nix-darwin, see documentation, something like
  `nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin#GNRSN/MacBook`

- Bootstrap home-manager, see documentation, something like
  `nix run home-manager -- switch --flake ~/dotfiles/nix-darwin#GNRSN`

- Symlink dotfiles into .config using
  `cd ~/dotfiles && stow .`

## Outline

### Nix

Build tool with DSL and package repository nixpkgs

### Nix Darwin

Acts as a glue between Nix and MacOS, allows declarative MacOS configuration inspired by NixOS

### Nix Home manager

Can "manage" supported software, e.g. managing zsh results in a generated zshrc and so forth

### GNU Stow

Symlink utility, I use this for configs since I want them to be editable with instant refresh. Having to home-manager switch for each config is worthless friction IMO. Could possibly be replaced with Nix `mkOutOfStoreSymlink`

See discussion in `https://github.com/omerxx/dotfiles/issues/10`
