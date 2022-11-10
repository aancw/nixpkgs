{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> {
    inherit system;
  }
, attrsets
,
}:


let
  packages = [
    "rectangle"
    "xbar"
    "obs-studio"
    "iriun-webcam"
    "clipy"
    "openvpn-connect"
    "adguard"
    # "googlechrome" # see system/darwin/homebrew.nix
  ];
in
attrsets.genAttrs packages (name: pkgs.callPackage ./${name}.nix { })
