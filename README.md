# @GNRSN dotfiles

## 🚧 WIP: Setup

- Clone this repo to `~/dotfiles`

- Install homebrew

- Install nix (multi user installation) through the determinate systems nix installer

- Bootstrap nix-darwin, see documentation, something like
  `nix run nix-darwin -- switch ~/dotfiles/nix-darwin#GNRSN/MacBook`

- Bootstrap home-manager, see documentation, something like
  `nix run home-manager -- switch ~/dotfiles/nix-darwin#GNRSN/MacBook`

- Symlink dotfiles into .config using
  `cd ~/dotfiles && stow .`
