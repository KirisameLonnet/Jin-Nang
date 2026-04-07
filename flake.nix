{
  description = "Flutter Cross-Platform Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
        
        # Linux - Required for Linux desktop app building
        linuxDeps = with pkgs; [
          pkg-config
          gtk3
          glib
          pcre2
          ninja
          cmake
          clang
        ];
        
        # macOS - Required for iOS/macOS building
        darwinDeps = with pkgs; [
          cocoapods
        ];

      in {
        devShells.default = pkgs.mkShell {
          name = "flutter-env";
          
          buildInputs = with pkgs; [
            flutter
            dart
          ] ++ lib.optionals stdenv.isLinux linuxDeps
            ++ lib.optionals stdenv.isDarwin darwinDeps;

          shellHook = ''
            # Fix Nix environment collisions with Xcode for iOS/macOS builds:
            # 1. DEVELOPER_DIR: Nix points this to a minimal Apple SDK lacking iOS Simulator
            # 2. SDKROOT: Nix locks this to its own macOS SDK, breaking iOS target resolution
            export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
            export SDKROOT=

            # Set FLUTTER_ROOT to the wrapped SDK (where bin/cache/pkg/sky_engine lives)
            export FLUTTER_ROOT=$(dirname $(dirname $(readlink -f $(which flutter))))
            export DART_ROOT=${pkgs.dart}

            echo "----------------------------------------------------"
            echo "🚀 Flutter Cross-Platform Dev Environment Loaded!"
            echo "📱 Host System: ${system}"
            echo "🛠️  Flutter path: $FLUTTER_ROOT"
            echo "----------------------------------------------------"
          '';
        };
      }
    );
}
