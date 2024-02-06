{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    alt-ergo-pin.url = "github:NixOS/nixpkgs/1b95daa381fa4a0963217a5d386433c20008208a";
  };

  outputs = {
    self,
    nixpkgs,
    alt-ergo-pin,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            why3 = prev.why3.override {version = "1.6.0";};
          })
        ];
      };

      alt-ergo =
        (import alt-ergo-pin {
          inherit system;
          config.allowUnfree = true;
        })
        .alt-ergo;
    in {
      formatter = pkgs.alejandra;
      devShell = pkgs.mkShell {
        packages = [
          pkgs.why3
          pkgs.zip

          # Solvers
          alt-ergo
          pkgs.cvc4
          pkgs.z3_4_12
        ];
      };
    });
}
