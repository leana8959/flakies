{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    opam-nix.url = "github:tweag/opam-nix";
  };

  outputs = { self, nixpkgs, flake-utils, opam-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        formatter = pkgs.nixfmt;

        devShell = let
          opam = opam-nix.legacyPackages.${system};
          why3 = pkgs.why3.overrideAttrs (prev: {
            version = "1.6.0";
            configureFlags = prev.configureFlags ++ [ "--enable-ide" ];
          });
          cvc4 = pkgs.cvc4.overrideAttrs (_: { version = "1.8"; });
        in pkgs.mkShell {
          packages = with pkgs; [
            why3

            cvc4
            z3_4_12
            opam.alt-ergo."2.4.1"
          ];
        };
      });
}
