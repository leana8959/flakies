{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      riscv64Pkgs = import nixpkgs {
        inherit system;
        crossSystem.config = "riscv32-linux-gnu";
      };
    in {
      devShells.default = riscv64Pkgs.stdenv.mkDerivation {
        name = "RISC-V Shell";
      };
    });
}
