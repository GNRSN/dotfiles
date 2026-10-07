{
  description = "@GNRSN Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
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
    };
}
