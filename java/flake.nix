{
  description = ''
    A java-flavored flake
  '';
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixunstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixunstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = nixunstable.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        formatter = pkgs.alejandra;
        packages = [
          pkgs.jdk
          pkgs.gradle
          unstable.jdt-language-server
        ];
      };
    });
}
