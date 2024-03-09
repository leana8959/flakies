{
  pkgs,
  # Path of the source folder
  src,
  # Name of the fderivation
  documentName ? "typst-document",
  typst ? pkgs.typst,
  fonts ? with pkgs; [iosevka lmodern cascadia-code],
  typstPackages ?
    pkgs.fetchgit {
      url = "https://github.com/typst/packages";
      rev = "aac865d4463dd00d7bafc05f31362db27b054309";
      hash = "sha256-Sj/1oICBwKiaBw9HWc81Z8WumkdPFkWKucjeI3kxUp4=";
    },
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
    paths = [typst];
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

  typst-pkgs-src = "${typstPackages}/packages";

  typst-package-cache = pkgs.stdenvNoCC.mkDerivation {
    name = "typst-packages-cache";
    src = typst-pkgs-src;
    dontBuild = true;
    installPhase = let
      package-path =
        if pkgs.stdenvNoCC.isLinux
        then "/typst/packages"
        else "/Library/Caches/typst/packages";
    in ''
      mkdir -p "$out${package-path}"
      cp -LR --reflink=auto "$src"/* "$out${package-path}"
    '';
  };

  docs = pkgs.stdenvNoCC.mkDerivation {
    pname = documentName;
    version = "0.0";
    inherit src;
    nativeBuildInputs = tools ++ [pkgs.bash];

    buildPhase = let
      where-cache-is =
        if pkgs.stdenvNoCC.isLinux
        then "XDG_CACHE_HOME"
        else "HOME";
    in ''
      # fix justfile shebang
      sed -i 's|#!/usr/bin/env \w*sh|#!${pkgs.bash}/bin/bash|g' justfile

      # export cache directory
      export ${where-cache-is}=${typst-package-cache}

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