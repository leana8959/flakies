{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/1b95daa381fa4a0963217a5d386433c20008208a";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-pinned,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-pinned = import nixpkgs-pinned {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShell = let
        why3 = pkgs.why3.overrideAttrs (prev: {
          version = "1.6.0";
          configureFlags = prev.configureFlags ++ ["--enable-ide"];
        });
        cvc4 = pkgs.cvc4.overrideAttrs (_: {version = "1.8";});
      in
        pkgs.mkShell {
          packages = with pkgs; [why3 cvc4 z3_4_12 pkgs-pinned.alt-ergo];
        };
    });
}
