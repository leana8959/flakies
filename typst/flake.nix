{
  description = ''
    A typst-flavored flake
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flakies.url = "git+https://git.earth2077.fr/leana/flakies";
  };

  outputs = {
    self,
    nixpkgs,
    nixunstable,
    flake-utils,
    flakies,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            typst = unstable.typst;
          })
        ];
      };
      unstable = import nixunstable {inherit system;};

      typstLib = pkgs.callPackage flakies.lib.typst {
        src = ./.;
      };
    in {
      formatter = pkgs.alejandra;

      devShells.default = typstLib.typstDevShell;

      packages.default = typstLib.typstDerivation;

      apps.buildLocal = typstLib.typstBuildLocal;
    });
}
