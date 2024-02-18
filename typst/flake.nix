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

      fonts = with pkgs; [
        iosevka
        lmodern
        cascadia-code
      ];

      typst-wrapped = pkgs.symlinkJoin {
        name = "typst";
        paths = [unstable.typst]; # Get the latest features !
        buildInputs = fonts;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = let
          # Create multiple flags, each points to a fonts folder of a derivation
          font-paths = builtins.concatStringsSep " " (map (p: "--font-path ${p}") fonts);
        in ''
          wrapProgram $out/bin/typst --append-flags "${font-paths}"
        '';
      };
    in {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        packages = [
          typst-wrapped
          pkgs.typst-lsp
          pkgs.sioyek
          pkgs.ghostscript
          pkgs.typstfmt
        ];
      };
    });
}
