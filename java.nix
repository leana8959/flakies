{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs; ([
    jdk17
    gradle
    jdt-language-server
  ]);
}
