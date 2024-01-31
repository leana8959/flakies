{
  description = ''
    A flake that has nothing in it... yet
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixunstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      unstable = import nixunstable {inherit system;};
    in {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        # put your packages here !
        buildInputs = with pkgs; [
        ];
      };
    });
}
