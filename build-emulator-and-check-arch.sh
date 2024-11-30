#!/usr/bin/env bash
set -ueo pipefail
set -x

nix build .#androidenv-emulator
file -b result/libexec/android-sdk/emulator/emulator
