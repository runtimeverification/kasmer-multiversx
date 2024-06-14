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
    mx-sdk-rs.url = "github:runtimeverification/mx-sdk-rs-flake/v0.50.3";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mx-sdk-rs-src = {
      url = "github:multiversx/mx-sdk-rs/v0.50.3";
      flake = false;
    };
    coindrip-protocol-sc-src = {
      url = "github:CoinDrip-finance/coindrip-protocol-sc/v1.0.1";
      flake = false;
    };
    mx-exchange-sc-src = {
      url = "github:multiversx/mx-exchange-sc/ee2d4645bd13c0f22f668a72bbc1b883753b6aee";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, rv-utils, k-framework, pyk, nixpkgs-pyk, mx-semantics, blockchain-k-plugin, mx-sdk-rs, rust-overlay, ... }@inputs:
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

          patchPhase = ''
            sed -i "s/^ROOT = .*$/ROOT = Path('.')/" src/kmxwasm/property_testing/paths.py
          '';

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
            kmultiversx-pyk
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

        kmxwasm-test-src = prev.stdenv.mkDerivation {
            inherit src version;
            pname = "kmxwasm-test-src";

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/deps/mx-sdk-rs
              cp -R ${inputs.mx-sdk-rs-src}/* $out/deps/mx-sdk-rs

              mkdir -p $out/deps/coindrip-protocol-sc
              cp -R ${inputs.coindrip-protocol-sc-src}/* $out/deps/coindrip-protocol-sc

              mkdir -p $out/deps/mx-exchange-sc
              cp -R ${inputs.mx-exchange-sc-src}/* $out/deps/mx-exchange-sc

              mkdir -p $out/tests
              cp -R tests/* $out/tests

              mkdir -p $out/package
              cp generate-claims.sh $out
              cp package/smoke-test.sh $out/package

              cp -R src $out
            '';
          };

        kmxwasm-test = prev.stdenv.mkDerivation {
          inherit version;

          src = final.kmxwasm-test-src;

          pname = "kmxwasm-test";

          buildInputs = with final; [
            cacert
            (rust-bin.stable.latest.default.override {
              targets = [ "wasm32-unknown-unknown" ];
            })
            mx-sdk-rs.packages.${system}.sc-meta
            wabt
            kmxwasm
          ] ++ (lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration);

          buildPhase = ''
            export USE_NIX=true
            export CARGO_HOME=$(pwd)

            ./package/smoke-test.sh && echo smoke  >> output
            ./generate-claims.sh    && echo claims >> output
          '';

          installPhase = ''
            mv output $out
          '';

          outputHashMode = "flat";
          outputHashAlgo = "sha256";
          outputHash = "sha256-nVEUU7CkLF1DpkYAwxZSQQTLQf+bhCzmOsBZzNKHqP4=";
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
            blockchain-k-plugin.overlay
            mx-semantics.overlays.default
            overlay
          ];
        };
      in {
        packages = {
          inherit (pkgs) kmxwasm kmxwasm-test kmxwasm-test-src;
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
