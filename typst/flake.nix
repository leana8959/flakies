{
  description = ''
    A typst-flavored flake
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # FIXME: fix ref before merge
    flakies.url = "git+https://git.earth2077.fr/leana/flakies?ref=typst_nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixunstable,
    flakies,
    flake-utils,
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

      typstLib = flakies.lib.typst {inherit pkgs;} {
        src = ./.;
      };
    in {
      formatter = pkgs.alejandra;

      devShells.default = typstLib.typstDevShell;

      packages.default = typstLib.typstDerivation;

      apps.buildLocal = typstLib.typstBuildLocal;
    });
}
