{
  description = "@GNRSN Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          # TODO: Should I move some to home-manager config?
          environment.systemPackages = [
            # Better cat, colors etc
            pkgs.bat
            # Manage nix-envs based on directory
            pkgs.direnv
            # Better ls
            pkgs.eza
            # Better find
            pkgs.fd
            # Fuzzy finder
            pkgs.fzf
            # Scan for secrets in git commits/history
            pkgs.gitleaks
            # Github cli
            pkgs.gh
            # Graphite cli
            pkgs.graphite-cli
            # json processor/query tool
            pkgs.jq
            # jq TUI playground
            pkgs.jqp
            # Git TUI
            pkgs.lazygit
            # Cross platform prompt
            pkgs.oh-my-posh
            # Automatic checks before committing
            pkgs.pre-commit
            # Faster grep
            pkgs.ripgrep
            # Hotkey daemon
            pkgs.skhd
            # Easy symlinks for dotfiles
            pkgs.stow
            # Turso cli
            pkgs.turso-cli
            # Vi improved
            pkgs.vim
            # Better cd
            pkgs.zoxide
          ];

          # Whitelist packages with restrictive licenses
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (pkgs.lib.getName pkg) [
              "graphite-cli"
            ];

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;

          # Set the version of nix we want to use
          nix.package = pkgs.nixVersions.nix_2_24;

          # Write directly into the nix.conf, try to replicate what NixInstaller left there
          # Some discrepancies between installer and NixDarwin
          # @see https://github.com/LnL7/nix-darwin/issues/889#issuecomment-2002505165
          nix.settings = {
            extra-nix-path = "nixpkgs=flake:nixpkgs";
            experimental-features = "nix-command flakes";
            # REVIEW: This was added by installer but isn't allowed by validation,
            # @see https://github.com/LnL7/nix-darwin/issues/864
            #
            upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
          };

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina

          # This property defines the version of nix to use, defaults to something pretty reasonable
          # system.nixpkgsRelease = 

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 4;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          nix.configureBuildUsers = true;
          nix.useDaemon = true;

          users.users.egunnarsson.home = "/Users/egunnarsson";
          home-manager.backupFileExtension = "before-home-manager";

          # Nice to have
          # Touch id for sudo
          security.pam.enableSudoTouchIdAuth = true;

          # Remap caps to ctrl
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToControl = true;

          # Disable press and hold for diacritics.
          # I want to be able to press and hold j and k
          # in VSCode with vim keys to move around.
          system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
        };
    in
    {
      # Since this isn't the same as our hostname we need to specify the config name during switch:
      # darwin-rebuild switch --flake .#GNRSN/MacBook-aarch64-darwin
      darwinConfigurations."GNRSN/MacBook-aarch64-darwin" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.egunnarsson = import ./home.nix;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."GNRSN/MacBook-aarch64-darwin".pkgs;
    };
}
