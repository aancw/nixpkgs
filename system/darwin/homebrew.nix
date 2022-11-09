{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  # mkIfCaskPresent = cask: mkIf (lib.any (x: x.name == cask) config.homebrew.casks);
  brewEnabled = config.homebrew.enable;
in
{
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  system.activationScripts.preUserActivation.text = mkIf brewEnabled ''
    if [ ! -f ${config.homebrew.brewPrefix}/brew ]; then
      ${pkgs.bash}/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';


  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  homebrew.masApps = {
    WhatsApp = 1147396723;
    "Tailscale" = 1475387142;
    "Microsoft Remote Desktop" = 1295203466;
    Telegram = 747648890;
    "Foxit PDF Reader" = 1032155965;
    "Enpass - Password Manager" = 732710998;
    Teams = 1543576480;
    NextDNS = 1464122853;
  };

  homebrew.casks = [
    "firefox"
    "google-chrome"
    "visual-studio-code"
    "blackhole-16ch"
    "postman"
    "gpg-suite"
    "adoptopenjdk11"
    "adoptopenjdk13"
    "meld"
    "adoptopenjdk8"
    "powershell-preview"
    "vagrant"
  ];

  # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
  # installed in `../home/default.nix` whenever possible.
  homebrew.brews = [
    "jenv"
    #"zsh"
    #"zsh-syntax-highlighting"
  ];

}
