{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    opam-nix.url = "github:tweag/opam-nix/main";
  };

  outputs = {
    self,
    nixpkgs,
    opam-nix,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            why3 =
              (prev.why3.override {version = "1.6.0";})
              .overrideAttrs (old: {configureFlags = (old.configureFlags or []) ++ ["--enable-ide"];});
            cvc4 = prev.cvc4.overrideAttrs (_: {version = "1.8";});
          })
        ];
      };
      opam = opam-nix.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          why3
          cvc4
          z3_4_12
          opam.alt-ergo."2.4.1"
        ];
      };
    });
}
