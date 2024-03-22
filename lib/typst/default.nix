{
  src,
  # tools,
  typst,
  ghostscript,
  typst-lsp,
  typstfmt,
  # fonts
  iosevka,
  lmodern,
  cm_unicode,
  fonts ? [iosevka lmodern cm_unicode],
  # typst packages
  typstPackages ?
    fetchgit {
      url = "https://github.com/typst/packages";
      rev = "aac865d4463dd00d7bafc05f31362db27b054309";
      hash = "sha256-Sj/1oICBwKiaBw9HWc81Z8WumkdPFkWKucjeI3kxUp4=";
    },
  # utils
  fetchgit,
  symlinkJoin,
  stdenvNoCC,
  mkShellNoCC,
  makeWrapper,
  writeShellApplication,
}: let
  tools = [
    typst-wrapped
    # TODO: https://github.com/nvarner/typst-lsp/pull/360
    # add the same thing for typst-lsp
    ghostscript
    typst-lsp
    typstfmt
  ];

  typst-wrapped = symlinkJoin {
    name = "typst";
    paths = [typst];
    buildInputs = fonts;
    nativeBuildInputs = [makeWrapper];
    postBuild = let
      # Create multiple flags, each points to a fonts folder of a derivation
      font-paths = builtins.concatStringsSep " " (map (p: "--font-path ${p}") fonts);
      # The fix for package cache doesn't work on darwin
    in ''
      wrapProgram $out/bin/typst --append-flags "${font-paths}"
    '';
  };

  typst-pkgs-src = "${typstPackages}/packages";

  typst-package-cache = stdenvNoCC.mkDerivation {
    name = "typst-packages-cache";
    src = typst-pkgs-src;
    dontBuild = true;
    installPhase = let
      package-path =
        if stdenvNoCC.isLinux
        then "/typst/packages"
        else "/Library/Caches/typst/packages";
    in ''
      mkdir -p "$out${package-path}"
      cp -LR --reflink=auto "$src"/* "$out${package-path}"
    '';
  };

  docs = stdenvNoCC.mkDerivation {
    pname = "typst-document";
    version = "0.0";
    inherit src;
    nativeBuildInputs = tools;

    buildPhase = let
      where-cache-is =
        if stdenvNoCC.isLinux
        then "XDG_CACHE_HOME"
        else "HOME";
    in ''
      # export cache directory
      export ${where-cache-is}=${typst-package-cache}

      # compile
      for f in *.typ; do
          typst compile "$f"
      done

      # fix
      for f in *.pdf; do
          SRC="$f"
          DST="''${f%.pdf}"_patched.pdf
          gs \
              -o "$DST" \
              -sDEVICE=pdfwrite \
              -dPDFSETTINGS=/prepress \
              "$SRC"
          mv "$DST" "$SRC"
      done
    '';

    installPhase = ''
      mkdir -p $out
      cp *.pdf "$out/"
    '';
  };

  copy-script = writeShellApplication {
    name = "copy-script";
    runtimeInputs = tools ++ [docs];
    text = ''
      cp --reflink=auto ${docs}/*.pdf .
    '';
  };
in {
  typstDevShell = mkShellNoCC {
    name = "typst-shell";
    packages = tools;
  };

  typstDerivation = docs;

  typstBuildLocal = {
    type = "app";
    program = "${copy-script}/bin/${copy-script.name}";
  };
}
