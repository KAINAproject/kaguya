{
  description = "MoonBit XR application for humanoid development, built on Three.js.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    moonbit-overlay.url = "github:moonbit-community/moonbit-overlay";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      perSystem = { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.moonbit-overlay.overlays.default
            ];
          };
        in {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.moonbit-bin.moonbit.latest
              pkgs.nodejs-slim_24
              pkgs.pnpm
              pkgs.android-tools
              pkgs.protobuf
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
