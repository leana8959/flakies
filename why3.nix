{ pkgs ? import <nixpkgs> {

    overlays = [
      (final: prev: {
        why3 = prev.why3.overrideAttrs (old: {
          version = "1.6.0";
        });
        cvc4 = prev.cvc4.overrideAttrs (old: {
          version = "1.8";
        });
      })
    ];
  }

}:

let
  opam-nix = (import
    (pkgs.fetchFromGitHub {
      owner = "tweag";
      repo = "opam-nix";
      rev = "73b179d9a5e4b9849e7b857eef9ad2a065e489be";
      hash = "sha256-38RprSyq38aGCsniQQaoYYmITzbgq2wssDQtVqnHfWE=";
    })).legacyPackages."${pkgs.system}";

in
  pkgs.mkShell {

    packages = with pkgs; ([
      why3
      cvc4
      z3_4_12

      opam-nix.alt-ergo."2.4.1"
    ]);

  }
