# @GNRSN dotfiles

## Setup

See [Setup](docs/SETUP.md)

## Docs

### Nix

Nix is a build tool/package manager with its own language (DSL) and package repository nixpkgs.
The installer created by determinate systems also allows easy uninstallation so we prefer this over the official installation script

Nixpkgs has stable releases and an unstable branch which is essentially the latest version/nightly build. However the flake lock-file pins the version of nixpkgs to a specific commit.

### Nix Darwin

Acts as a glue between Nix and MacOS, allows declarative MacOS configuration inspired by NixOS. Manages itself after bootstrapping.

```
sudo darwin-rebuild switch --flake .#GNRSN/MacBook
```

Activation ends by running `scripts/log-packages.sh`, which dumps the exact installed versions to `packages.txt` and `brew.txt` so upgrades show up in git history. Exclusions are defined at the top of the script.

### GNU Stow

Symlink utility, I use this for configs since I want them to be editable with instant refresh.

See discussion in `https://github.com/omerxx/dotfiles/issues/10`

### Rust

Requires to be installed for dependencies that compile from source.
Rustup manages the rust entire rust toolchain, installing versioned cargo through nix seemed overkill for now.
This approach requires installing the toolchain manually through: `rustup default stable`

### JS Toolchains

Node JS, nub and pnpm are installed through Mise (`dot-config/mise/config.toml`), bump them with `mise upgrade`

nub and pnpm come from the mise registry as native binaries, avoiding the node bootstrap of npm globals and corepack

pnpm switches to the version in a project's `packageManager` field by itself, so corepack is not needed

Global JS CLIs go in the same `[tools]` table through the npm backend, e.g. `"npm:<package>" = "latest"`
