{
  description = "kmxwasm - Symbolic execution for the MulitversX blockchain with the Wasm semantics, using pyk.";

  inputs = {
    mx-semantics.url = "github:runtimeverification/mx-semantics/v0.1.115";
    k-framework.follows = "mx-semantics/k-framework";
    poetry2nix.follows = "k-framework/poetry2nix";
    nixpkgs.follows = "k-framework/nixpkgs";
    flake-utils.follows = "k-framework/flake-utils";
    rv-utils.follows = "k-framework/rv-utils";
    blockchain-k-plugin.follows = "mx-semantics/blockchain-k-plugin";
    mx-sdk-rs.url = "github:runtimeverification/mx-sdk-rs-flake/v0.50.3";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, rv-utils, k-framework, mx-semantics, blockchain-k-plugin, mx-sdk-rs, rust-overlay, ... }@inputs:
    let overlay = (final: prev:
      let
        src = prev.lib.cleanSource (prev.nix-gitignore.gitignoreSourcePure [
          "/.github"
          "flake.lock"
          ./.gitignore
        ] ./.);

        version = self.rev or "dirty";

        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { pkgs = prev; };
      in {
        kmxwasm-pyk = poetry2nix.mkPoetryApplication {
          python = prev.python310;
          projectDir = ./kmxwasm;
          src = rv-utils.lib.mkSubdirectoryAppSrc {
            pkgs = import nixpkgs { system = prev.system; };
            src = ./kmxwasm;
            subdirectories = [ "kmultiversx" ];
            cleaner = poetry2nix.cleanPythonSources;
          };

          patchPhase = ''
            sed -i "s/^ROOT = .*$/ROOT = Path('.')/" src/kmxwasm/property_testing/paths.py
          '';

          overrides = poetry2nix.overrides.withDefaults
          (finalPython: prevPython: {
            k-framework = prev.pyk-python310;
            kmultiversx = final.kmultiversx-pyk;
          });
          groups = [ ];
          checkGroups = [ ];
          postInstall = ''
            mkdir -p $out/${prev.python310.sitePackages}/kmxwasm/kdist/plugin
            cp -r ${prev.blockchain-k-plugin-src}/* $out/${prev.python310.sitePackages}/kmxwasm/kdist/plugin/
          '';
        };

        kmxwasm = prev.stdenv.mkDerivation {
          pname = "kmxwasm";
          inherit src version;

          buildInputs = with final; [
            secp256k1
            prev.pyk-python310
            k-framework.packages.${system}.k
            kmultiversx-pyk
            kmxwasm-pyk
            cmake
            openssl.dev
            clang
            mpfr
            pkg-config
            procps
            llvmPackages.llvm
            boost
          ];

          dontUseCmakeConfigure = true;

          nativeBuildInputs = [ prev.makeWrapper ];

          enableParallelBuilding = true;

          buildPhase = ''
            export XDG_CACHE_HOME=$(pwd)
            export K_OPTS="-Xmx8G -Xss512m"
            export APPLE_SILICON=${
              prev.lib.optionalString
              (prev.stdenv.isAarch64 && prev.stdenv.isDarwin)
              "true"
            }

            kdist -v build                \
              -j$NIX_BUILD_CORES          \
              "mxwasm-semantics.*"        \
              "mx-semantics.llvm-kasmer"
          '';

          installPhase = ''
            mkdir -p $out
            cp -r ./kdist-*/* $out/

            mkdir -p $out/bin
            makeWrapper ${final.kmxwasm-pyk}/bin/kasmer $out/bin/kasmer \
              --prefix PATH : ${
                prev.lib.makeBinPath [
                  prev.which
                  k-framework.packages.${prev.system}.k
                ]
              } \
              --set KDIST_DIR $out
          '';
        };

        kmxwasm-test-shell = prev.mkShell {
          packages = with final; [
            (rust-bin.stable.latest.default.override {
              targets = [ "wasm32-unknown-unknown" ];
            })
            mx-sdk-rs.packages.${system}.sc-meta
            wabt
            kmxwasm
          ];

          buildInputs = with final; [
            cacert
            pkg-config
            openssl
          ] ++ (lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration);

          shellHook = ''
            export CARGO_HOME=$(pwd)
            export USE_NIX=true
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
            rust-overlay.overlays.default
            k-framework.overlay
            k-framework.overlays.pyk
            blockchain-k-plugin.overlay
            mx-semantics.overlays.default
            overlay
          ];
        };
      in {
        packages = {
          inherit (pkgs) kmxwasm kmxwasm-test-shell;
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
