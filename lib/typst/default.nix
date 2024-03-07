{pkgs}: {
  src,
  documentName ? "typst-document",
  fonts ? with pkgs; [iosevka lmodern cascadia-code],
}: let
  tools = with pkgs; [
    typst-wrapped
    # TODO: https://github.com/nvarner/typst-lsp/pull/360
    # add the same thing for typst-lsp
    typst-lsp
    sioyek
    ghostscript
    typstfmt
    just
  ];

  typst-wrapped = pkgs.symlinkJoin {
    name = "typst";
    paths = [pkgs.typst];
    buildInputs = fonts;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = let
      # Create multiple flags, each points to a fonts folder of a derivation
      font-paths = builtins.concatStringsSep " " (map (p: "--font-path ${p}") fonts);
      # The fix for package cache doesn't work on darwin
    in ''
      wrapProgram $out/bin/typst --append-flags "${font-paths}"
    '';
  };

  docs = pkgs.stdenvNoCC.mkDerivation {
    pname = documentName;
    version = "0.0";
    inherit src;
    nativeBuildInputs = tools;

    buildPhase = ''
      # Hack for the package downloading
      mkdir -p fakehome/
      HOME=./fakehome
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
      cp --reflink=auto ${docs}/*.pdf .
    '';
  };
in {
  typstDevShell = pkgs.mkShellNoCC {
    packages = tools;
  };

  typstDerivation = docs;

  typstBuildLocal = {
    type = "app";
    program = "${copy-script}/bin/${copy-script.name}";
  };
}
