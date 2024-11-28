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
          packages.android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            emulator
          ]);
        in
        {
          inherit packages;
        }
      )
    )
  ;
}