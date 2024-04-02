{
  description = "MX backend";

  inputs = {
    nixpkgs.follows = "pyk/nixpkgs";
    k-framework.url = "github:runtimeverification/k/v6.3.68";
    flake-utils.follows = "k-framework/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, k-framework, ... }@inputs:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ 
            k-framework.packages.${pkgs.system}.k
            poetry 
          ];
        };
      });
}
