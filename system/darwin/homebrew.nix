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
  homebrew.global.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.onActivation.upgrade = true;
  homebrew.global.brewfile = true;
   #homebrew.caskArgs = {
     # force = true;
     #verbose = true;
   #};

  homebrew.taps = [
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  homebrew.masApps = {
    WhatsApp = 1147396723;
    "Tailscale" = 1475387142;
    "Microsoft Remote Desktop" = 1295203466;
    Telegram = 747648890;
    "Foxit PDF Reader" = 1032155965;
    #"Enpass - Password Manager" = 732710998;
    Teams = 1543576480;
    NextDNS = 1464122853;
    #"Hidden Bar" =  1452453066;
  };

  homebrew.casks = [
    "gpg-suite"
    "openvpn-connect"
    "spotify"
    #"macs-fan-control"
    "github"
    #"steam"
    "cloudflare-warp"
    "teamviewer"
    "adguard"
    "shottr"
    "tor-browser"
    "keka"
    "the-unarchiver"
    "warp"
    #"battery"
    "raycast"
    "openinterminal"
    "font-meslo-lg-nerd-font"
    "gittyup"
    # only activate when using fresh machine, it will replace the system 
     "obsidian"
     "firefox"
     "thunderbird"
     "google-drive"
     "jetbrains-toolbox"
     "google-chrome"
     "brave-browser"
     "megasync"
     "wireshark"
     #"burp-suite"
     "orbstack"
     "eul"
     "pandoc"
     "bundletool"
     #"radare2"
  ];

  # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
  # installed in `../home/default.nix` whenever possible.
  homebrew.brews = [
    "nuclei"
    "jenv"
    "radare2"
    #"zsh"
    #"zsh-syntax-highlighting"
  ];

}
