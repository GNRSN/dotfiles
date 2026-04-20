# Setup

1. Prerequisites:

- Setup ssh for github
- Install homebrew
- Setup pass from encrypted repo

2. Clone this repo to `~/dotfiles` (note: This path is currently/still expected)

3. Install nix (multi user installation) through the determinate systems nix installer

- Bootstrap nix-darwin, see documentation, something like
  `nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin#GNRSN/MacBook`

4. Symlink dotfiles into .config using
   `cd ~/dotfiles && stow .`
