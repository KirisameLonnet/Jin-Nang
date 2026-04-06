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
            # Set FLUTTER_ROOT so tooling can find the SDK
            export FLUTTER_ROOT=${pkgs.flutter.unwrapped or pkgs.flutter}
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
