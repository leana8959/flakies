rec {
  default = vanilla;

  haskell = {
    description = "Haskell-flavored flake";
    path = ./haskell;
  };

  c = {
    description = "Clang flake";
    path = ./c;
  };

  riscv32 = {
    description = "RISC-V gcc";
    path = ./riscv32;
  };

  java = {
    description = "Java jdtls flake";
    path = ./java;
  };

  rust = {
    description = "Rust flake";
    path = ./rust;
  };

  scala = {
    description = "Scala Metals flake";
    path = ./scala;
  };

  why3 = {
    description = "why3 flake for PRGC class";
    path = ./why3;
  };

  typst = {
    description = "Typst flake with templates";
    path = ./typst;
  };

  vanilla = {
    description = "A simple flake that can be extended";
    path = ./vanilla;
  };
}
