{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk17;
    in {
      devShell = pkgs.mkShell {
        formatter = pkgs.alejandra;
        packages = with pkgs; [jdk gradle jdt-language-server];
      };
    });
}
