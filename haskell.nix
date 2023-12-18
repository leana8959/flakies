{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-pinned,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          stack
          haskell.compiler.ghc947
          (haskell-language-server.override {
            supportedGhcVersions = ["947"];
          })
          haskellPackages.fourmolu
          haskellPackages.stylish-haskell
          haskellPackages.hoogle
          haskellPackages.cabal-fmt
          haskellPackages.cabal-install
        ];
      };
    });
}
