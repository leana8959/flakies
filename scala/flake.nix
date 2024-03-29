{
  description = ''
    A scala-flavored flake
  '';
  # credit: https://zendesk.engineering/using-nix-to-develop-and-package-a-scala-project-cadccd56ad06
  # for neovim users: https://github.com/scalameta/nvim-metals/pull/97/files

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
      pkgs = import nixpkgs {inherit system;};
    in {
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        JAVA_HOME = pkgs.jdk;
        packages = with pkgs; [
          sbt
          ammonite
          metals
          scalafmt
        ];
      };
    });
}
