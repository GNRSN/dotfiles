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

    # This tool can be used to search for nixpkgs-versions containing specfic package-versions
    # https://lazamar.co.uk/nix-versions/?package=nodejs
    # NOTE: Package name is not the same as specified name for importing the package,
    # it is listed in a separate field on https://search.nixos.org
    # TODO: We no longer need this because we've caught up to latest stable at work. Keeping here through since I may need to re-use this method again
    nodejs-20-14-0_pkgs = {
      url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nodejs-20-14-0_pkgs,
    }:
    let
      system = "aarch64-darwin";
    in
    {
      # Since this isn't the same as our hostname we need to specify the config name during switch:
      # darwin-rebuild switch --flake .#GNRSN/MacBook
      # Bootstrap: nix run [darwin]/main -- switch --flake .#GNRSN/MacBook
      darwinConfigurations."GNRSN/MacBook" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          (import ./modules/darwin.nix {
            inherit system self;
          })
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."GNRSN/MacBook".pkgs;

      # Bootstrap: nix run home-manager/master -- switch --flake .#GNRSN
      homeConfigurations."GNRSN" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          (import ./modules/home.nix {
            nodejs-20-14-0_pkgs = nodejs-20-14-0_pkgs.legacyPackages.${system};
          })
        ];
      };
    };
}
