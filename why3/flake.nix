{
  description = ''
    why3 ide 1.6.0 https://www.why3.org/
    - alt-ergo 2.4.1
    - cvc4 1.8
    - z3 4.12.2
  '';

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    alt-ergo-pin.url = "github:NixOS/nixpkgs/1b95daa381fa4a0963217a5d386433c20008208a";
  };

  outputs = {
    self,
    nixpkgs,
    alt-ergo-pin,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            why3 = prev.why3.override {version = "1.6.0";};
          })
        ];
      };

      alt-ergo =
        (import alt-ergo-pin {
          inherit system;
          config.allowUnfree = true;
        })
        .alt-ergo;

      provers = [
        alt-ergo
        pkgs.cvc4
        pkgs.z3_4_12
      ];

      why3-wrapped = pkgs.symlinkJoin {
        name = "why3";
        # Generate configuration in the store, and wrap why3 with the corresponding option
        paths = [pkgs.why3];
        buildInputs = provers;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          $out/bin/why3 config detect --config=$out/why3.conf
          wrapProgram $out/bin/why3 --add-flags "--config=$out/why3.conf"
        '';
      };
    in {
      formatter = pkgs.alejandra;
      devShell = pkgs.mkShell {
        packages = [
          pkgs.zip # used for exporting session
          why3-wrapped
        ];
      };
    });
}
