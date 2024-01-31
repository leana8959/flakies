{
  description = ''
    A clang-flavored flake
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        llvm = pkgs.llvmPackages_16;
      in {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.clangStdenv.mkDerivation rec {
          name = "Clang shell";
          CPATH = pkgs.lib.makeSearchPathOutput "dev" "include" buildInputs;
          nativeBuildInputs = [
            pkgs.gnumake
            pkgs.clang-tools # fix headers not found
            # # debugger
            # llvm.lldb
            # pkgs.gdb
          ];
          buildInputs = [
            llvm.libcxx # stdlib for cpp
          ];
        };
      }
    );
}
