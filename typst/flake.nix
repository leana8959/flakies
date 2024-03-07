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
        typst-wrapped
        # TODO: https://github.com/nvarner/typst-lsp/pull/360
        # add the same thing for typst-lsp
        pkgs.typst-lsp
        pkgs.sioyek
        pkgs.ghostscript
        pkgs.typstfmt
        pkgs.just
      ];

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

      docs = pkgs.stdenvNoCC.mkDerivation {
        pname = "typst-document";
        version = "0.0";
        src = ./.;
        nativeBuildInputs = tools;

        buildPhase = ''
          just compileAndFix
        '';

        installPhase = ''
          mkdir -p $out
          cp *.pdf "$out/"
        '';
      };

      copy-script = pkgs.writeShellApplication {
        name = "copy-script";
        runtimeInputs = tools ++ [docs];
        text = ''
          cp ${docs}/*.pdf .
        '';
      };
    in {
      formatter = pkgs.alejandra;

      devShell = pkgs.mkShellNoCC {packages = tools;};

      packages.default = docs;

      apps.buildLocal = flake-utils.lib.mkApp {drv = copy-script;};
    });
}
