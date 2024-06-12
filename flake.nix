{
  description = "kmxwasm - Symbolic execution for the MulitversX blockchain with the Wasm semantics, using pyk.";

  inputs = {
    k-framework.url = "github:runtimeverification/k/v7.0.120";
    pyk.url = "github:runtimeverification/k/v7.0.120?dir=pyk";
    nixpkgs-pyk.follows = "pyk/nixpkgs";
    poetry2nix.follows = "pyk/poetry2nix";
    mx-semantics.url = "github:runtimeverification/mx-semantics/v0.1.76";
    nixpkgs.follows = "k-framework/nixpkgs";
    flake-utils.follows = "k-framework/flake-utils";
    rv-utils.url = "github:runtimeverification/rv-nix-tools";
    blockchain-k-plugin.follows = "mx-semantics/blockchain-k-plugin";
  };
  outputs = { self, nixpkgs, flake-utils, rv-utils, k-framework, pyk, nixpkgs-pyk, mx-semantics, blockchain-k-plugin, ... }@inputs:
    let overlay = (final: prev:
      let
        src = prev.lib.cleanSource (prev.nix-gitignore.gitignoreSourcePure [
          "/.github"
          "flake.lock"
          ./.gitignore
        ] ./.);

        version = self.rev or "dirty";

        nixpkgs-pyk = import inputs.nixpkgs-pyk {
          system = prev.system;
          overlays = [ pyk.overlay ];
        };

        python310-pyk = nixpkgs-pyk.python310;

        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { pkgs = nixpkgs-pyk; };
      in {
        kmxwasm-pyk = poetry2nix.mkPoetryApplication {
          python = nixpkgs-pyk.python310;
          projectDir = ./kmxwasm;
          src = rv-utils.lib.mkSubdirectoryAppSrc {
            pkgs = import nixpkgs { system = prev.system; };
            src = ./kmxwasm;
            subdirectories = [ "kmultiversx" ];
            cleaner = poetry2nix.cleanPythonSources;
          };
          overrides = poetry2nix.overrides.withDefaults
          (finalPython: prevPython: {
            pyk = nixpkgs-pyk.pyk-python310;
            kmultiversx = final.kmultiversx-pyk;
          });
          groups = [ ];
          checkGroups = [ ];
          postInstall = ''
            mkdir -p $out/${nixpkgs-pyk.python310.sitePackages}/kmxwasm/kdist/plugin
            cp -r ${prev.blockchain-k-plugin-src}/* $out/${nixpkgs-pyk.python310.sitePackages}/kmxwasm/kdist/plugin/
          '';
        };

        kmxwasm = prev.stdenv.mkDerivation {
          pname = "kmxwasm";
          inherit src version;

          buildInputs = with final; [
            secp256k1
            nixpkgs-pyk.pyk-python310
            k-framework.packages.${system}.k
            kmultiversx
            kmxwasm-pyk
            cmake
            openssl.dev
            clang
            mpfr
            pkg-config
            procps
            llvmPackages.llvm
          ];

          dontUseCmakeConfigure = true;

          nativeBuildInputs = [ prev.makeWrapper ];

          enableParallelBuilding = true;

          buildPhase = ''
            export XDG_CACHE_HOME=$(pwd)
            ${
              prev.lib.optionalString
              (prev.stdenv.isAarch64 && prev.stdenv.isDarwin)
              "APPLE_SILICON=true"
            } K_OPTS="-Xmx8G -Xss512m" kdist -v build -j$NIX_BUILD_CORES
          '';

          installPhase = ''
            mkdir -p $out
            cp -r ./kdist-*/* $out/
          '';
        };
      }
    );
    in flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            k-framework.overlay
            blockchain-k-plugin.overlay
            mx-semantics.overlays.default
            overlay
          ];
        };
      in {
        packages = {
          inherit (pkgs) kmxwasm;
          default = pkgs.kmxwasm;
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ 
            k-framework.packages.${pkgs.system}.k
            poetry
            wabt
          ];
        };
      }) // {
        overlays.default = overlay;
      };
}
