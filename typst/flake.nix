{
  description = ''
    A typst-flavored flake
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
      tools = [
        unstable.typst # Get the latest features !
        pkgs.typst-lsp
        pkgs.sioyek
        pkgs.ghostscript
        pkgs.typstfmt
      ];
      fonts = with pkgs; [
        (nerdfonts.override {fonts = ["CascadiaCode" "JetBrainsMono" "Meslo"];})
        lmodern
        cascadia-code
      ];
    in {
      devShells.default = pkgs.mkShell {
        buildInputs =
          tools ++ fonts;
      };
    });
}
