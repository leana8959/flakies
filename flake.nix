{
  description = "Léana's collection of flake templates";
  outputs = {self}: {
    templates = {
      haskell.path = ./haskell;

      java.path = ./java;

      rust.path = ./rust;

      scala.path = ./scala;

      why3 = {
        description = "why3 template for PRGC class";
        path = ./why3;
      };

      typst.path = ./typst;

      vanilla.path = ./vanilla;
    };
  };
}
