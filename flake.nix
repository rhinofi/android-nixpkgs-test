{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=5083ec887760adfe12af64830a66807423a859a7";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, android-nixpkgs, flake-utils, ... }:
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
          androidPkgs = (pkgs.androidenv.composeAndroidPackages {
            includeEmulator = true;
          });
          android-nixpkgs-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            emulator
          ]);
        in
        {
          packages = {
            default = android-nixpkgs-sdk;
            androidenv-emulator = androidPkgs.emulator;
            androidPkgs = androidPkgs;
          };
        }
      )
    )
  ;
}
