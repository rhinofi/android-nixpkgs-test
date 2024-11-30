{
  inputs = {
    nixpkgs.url = "github:hadilq/nixpkgs/androidenv-upgrade-to-repository2-3";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      android-nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      (
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              android_sdk.accept_license = true;
              allowUnfree = true;
            };
          };
          androidPkgs = (
            pkgs.androidenv.composeAndroidPackages {
              includeEmulator = true;
              emulatorVersion = "35.4.2";
            }
          );
          android-nixpkgs-sdk = android-nixpkgs.sdk.${system} (
            sdkPkgs: with sdkPkgs; [
              cmdline-tools-latest
              emulator
            ]
          );
        in
        {
          packages = {
            default = android-nixpkgs-sdk;
            androidenv-emulator = androidPkgs.emulator;
            androidPkgs = androidPkgs;
          };
        }
      )
    );
}
