{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    alt-ergo-pin.url = "github:NixOS/nixpkgs/1b95daa381fa4a0963217a5d386433c20008208a";
    why3-pin.url = "github:NixOS/nixpkgs/e12230e71628a460bf82a8477242280868efe799";
  };

  outputs = {
    self,
    nixpkgs,
    alt-ergo-pin,
    why3-pin,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      alt-ergo =
        (import alt-ergo-pin {
          inherit system;
          config.allowUnfree = true;
        })
        .alt-ergo;

      why3 =
        (import why3-pin {
          inherit system;
          overlays = [
            (final: prev: {
              why3 = prev.why3.overrideAttrs (old: {configureFlags = (old.configureFlags or []) ++ ["--enable-ide"];});
            })
          ];
        })
        .why3;

      devTools = let
        ocamlPackages = [alt-ergo why3];
        tools = with pkgs; [cvc4 z3_4_12 zip];
      in
        ocamlPackages ++ tools;
    in {
      devShell = pkgs.mkShell {packages = devTools;};
      formatter = pkgs.alejandra;
    });
}
