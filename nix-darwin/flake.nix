{
  description = "@GNRSN Darwin configuration";

  inputs = {
    # REVIEW: Do I really want to follow unstable or use the latest stable? -24.05
    # Since stable channels are release about every 6 months I assume this is a date?
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.vim
            pkgs.direnv
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
        };
    in
    {
      # Since this isn't the same as our hostname we need to specify the config name during switch:
      # darwin-rebuild switch --flake .#GNRSN/MacBook-aarch64-darwin
      darwinConfigurations."GNRSN/MacBook-aarch64-darwin" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."GNRSN/MacBook-aarch64-darwin".pkgs;
    };
}
