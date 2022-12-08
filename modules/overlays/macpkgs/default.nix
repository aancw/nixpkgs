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
    #"xbar"
    "obs-studio"
    #"iriun-webcam"
    "clipy"
    "openvpn-connect"
    "adguard"
    "github-desktop"
    "macs-fan-control"
    "obsidian"
    "spotify"
    "steam"
    # "googlechrome" # see system/darwin/homebrew.nix
  ];
in
attrsets.genAttrs packages (name: pkgs.callPackage ./${name}.nix { })
