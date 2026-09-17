{
  description = "MoonBit XR application for humanoid development, built on Three.js.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    moonbit-overlay.url = "github:moonbit-community/moonbit-overlay";
    zenoh-ts = {
      url = "github:eclipse-zenoh/zenoh-ts/1.10.1";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      zenohOverlay = final: _prev: {
        zenoh-bridge-remote-api = final.rustPlatform.buildRustPackage {
          pname = "zenoh-bridge-remote-api";
          version = "1.10.1";

          src = inputs.zenoh-ts;

          cargoHash = "sha256-A2Q9BzcZLPVowENn77+XoplpIt9dJOPBgY6wQ953kWQ=";
          cargoBuildFlags = [
            "--package"
            "zenoh-bridge-remote-api"
          ];
          doCheck = false;

          installPhase = ''
            install -Dm755 target/${final.stdenv.hostPlatform.rust.rustcTarget}/release/zenoh-bridge-remote-api \
              $out/bin/zenoh-bridge-remote-api
          '';

          meta = {
            description = "Zenoh router with the remote API WebSocket plugin";
            homepage = "https://github.com/eclipse-zenoh/zenoh-ts";
            license = [ final.lib.licenses.asl20 final.lib.licenses.epl20 ];
            mainProgram = "zenoh-bridge-remote-api";
            platforms = final.lib.platforms.unix;
          };
        };
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake.overlays.zenoh = zenohOverlay;

      perSystem = { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.moonbit-overlay.overlays.default
              zenohOverlay
            ];
          };
        in {
          packages.zenoh-bridge-remote-api = pkgs.zenoh-bridge-remote-api;

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.moonbit-bin.moonbit.latest
              pkgs.nodejs-slim_24
              pkgs.pnpm
              pkgs.android-tools
              pkgs.zenoh-bridge-remote-api
            ] ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.chromium;

            shellHook = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
              export PLAYWRIGHT_EXECUTABLE_PATH="${pkgs.chromium}/bin/chromium"
            '';
          };
        };

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    };
}
