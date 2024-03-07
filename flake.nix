{
  description = "Léana's collection of flake templates";

  outputs = {self}: {
    lib = import ./lib;

    templates = import ./templates.nix;
  };
}
