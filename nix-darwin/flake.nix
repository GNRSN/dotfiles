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
      system = "aarch64-darwin";
      lib = nixpkgs.lib;
      configuration =
        { pkgs, ... }:
        {
          # Remaining:
          # Rust/rustup

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          # TODO: move most to home-manager config
          environment.systemPackages = [
            # Manage nix-envs based on directory
            pkgs.direnv
            # Vi improved
            pkgs.vim
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
            upgrade-nix-store-path-url = "https://install.determinate.systems/nix-upgrade/stable/universal";
            allowed-users = [ "*" ];
          };

          # default shell on catalina
          programs.zsh.enable = true;

          # This property defines the version of nix to use, defaults to something pretty reasonable
          # system.nixpkgsRelease = 

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 4;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = system;

          nix.configureBuildUsers = true;
          nix.useDaemon = true;

          # TODO: Is this still required? try without
          users.users.egunnarsson.home = "/Users/egunnarsson";

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
        inherit system;
        modules = [
          configuration
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."GNRSN/MacBook-aarch64-darwin".pkgs;

      homeConfigurations."GNRSN" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
      };
    };
}
