# @GNRSN dotfiles

## 🚧 WIP: Setup

- Prerequisite: Install homebrew

- Clone this repo to `~/dotfiles` (note: This path is expected)

- Install nix (multi user installation) through the determinate systems nix installer

- Bootstrap nix-darwin, see documentation, something like
  `nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin#GNRSN/MacBook`

- Symlink dotfiles into .config using
  `cd ~/dotfiles && stow .`

## Docs

### Nix

Nix is a build tool/package manager with its own language (DSL) and package repository nixpkgs.
The installer created by determinate systems also allows easy uninstallation so we prefer this over the official installation script

Nixpkgs has stable releases and an unstable branch which is essentially the latest version/nightly build. However the flake lock-file pins the version of nixpkgs to a specific commit.

### Nix Darwin

Acts as a glue between Nix and MacOS, allows declarative MacOS configuration inspired by NixOS. Manages itself after bootstrapping.

```
sudo darwin-rebuild switch --flake .#GNRSN/MacBook && brew bundle dump --file=~/dotfiles/brew.txt --force && find /run/current-system/sw/bin/ -type l -exec readlink {} \; \
  | sed -E 's|[^-]+-([^/]+)/.*|\1|g' \
  | sort -u \
  | grep -vE '^(bash-interactive-.*|darwin-help|darwin-rebuild|darwin-uninstaller|darwin-option|darwin-version|nix-info|texinfo-interactive-.*)$' \
  > packages.txt
```

### GNU Stow

Symlink utility, I use this for configs since I want them to be editable with instant refresh.

See discussion in `https://github.com/omerxx/dotfiles/issues/10`

### Rust

Requires to be installed for dependencies that compile from source.
Rustup manages the rust entire rust toolchain, installing versioned cargo through nix seemed overkill for now.
This approach requires installing the toolchain manually through: `rustup default stable`
