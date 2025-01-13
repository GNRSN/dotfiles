{
  description = "@GNRSN Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sqld_pkgs = {
      url = "https://github.com/NixOS/nixpkgs/archive/4989a246d7a390a859852baddb1013f825435cee.tar.gz";
    };

    # Flake that downloads fonts from apples website + patches with nerdfonts. These are not installed system wide by default
    # https://github.com/Lyndeno/apple-fonts.nix
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      sqld_pkgs,
      apple-fonts,
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
            inherit system self apple-fonts;
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
            sqld_pkgs = sqld_pkgs.legacyPackages.${system};
          })
        ];
      };
    };
}
