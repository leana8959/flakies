{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs; ([
    jdk17
    ammonite # REPL
    metals   # LSP
    sbt      # build tool
    scala_3
    scalafmt
    scalafix
  ]);
}
