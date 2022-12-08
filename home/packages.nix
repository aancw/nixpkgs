{ config, pkgs, lib, ... }:

{
  # Packages with configuration --------------------------------------------------------------- {{{

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
    theme = "TwoDark";
  };
  # Direnv, load and unload environment variables depending on the current directory.

  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
    };
  };

  # creating file with contents, that file will stored in nix-store
  # then symlink to homeDirectory.
  home.file.".gnupg/gpg-agent.conf".source = pkgs.writeTextFile {
    name = "home-gpg-agent.conf";
    text = lib.optionalString (pkgs.stdenv.isDarwin) ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
  };

  home.packages = with pkgs;
    [
      ################################## 
      # common
      ################################## 
      coreutils
      curl
      wget
      tree
      gnupg # required for pass git
      # pass # password management
      ack
      fswatch

      ################################## 
      # Platform specific
      ################################## 

      ################################## 
      # Manager
      ################################## 
      yadm

      ################################## 
      # Productivity
      ################################## 
      fzf # finder
      fzy
      neofetch # fancy fetch information
      du-dust # fancy du
      fd # fancy find
      jq # JSON in shell
      ripgrep # another yet of grep
      ffmpeg
      imagemagick
      himalaya # CLI based email client

      ################################## 
      # Development
      ################################## 
      ansible
      git
      rustup
      neovim
      podman
      podman-compose
      qemu
      babelfish
      paperkey
      shellcheck
      #gcc
      libxml2
      libiconv # rust gcc
      # yarn # currently defined in devShell.nix
      tokei
      go
      # google-cloud-sdk
      # nodejs-16_x
      # gitlab-runner
      comby
      python310
      pkg-config
      mob
      postman
      vscode
      meld
      powershell
      vagrant
      #adoptopenjdk-bin
      #adoptopenjdk-openj9-bin-8
      #adoptopenjdk-openj9-bin-16
      # openvpn # currently not used

      ################################## 
      # Shell Integrations
      ################################## 
      tmux # terminal multi-plexer (multiply terminal)
      starship # theme for shell (bash,fish,zsh)

      ################################## 
      # Misc
      ################################## 
      obs-studio
      asciinema
      aria
      ffmpeg
      gifsicle
      packer
      wireshark
      audacity

      ################################## 
      # Sec
      ##################################
      ffuf
      jadx
      sqlmap
      gdb
      exiftool
      scrcpy
      apktool
      nuclei
      nmap

      ################################## 
      # Communication
      ################################## 
      discord
      #thunderbird
      # (zoom-us.overrideAttrs
      #   (oldAttrs: rec
      #   {
      #     src = lib.optionals pkgs.stdenv.isDarwin fetchurl {
      #       url = "https://zoom.us/client/${oldAttrs.version}/Zoom.pkg";
      #       sha256 = "sha256-BNJz48Kx17l3n4EN8bW8WL8KvXdRCGoiChBjnx9AUDk=";
      #     };
      #   }
      #   )
      # )
      ################################## 
      # Useful Nix related tools
      ################################## 
      cachix
      comma # run without install
      # nodePackages.node2nix # use with comma 
      # rnix-lsp # use in neovim and install with nvim-lsp-install
      home-manager
      nix-prefetch-git
      # nodePackages.node2nix # use with comma 
      # yarn2nix
    ] ++ lib.optionals
      stdenv.isDarwin
      [
        mas
        #xbar
        rectangle
        cocoapods
        m-cli # useful macOS CLI commands
        xcode-install
        #iriun-webcam
        clipy
        # googlechrome
      ];
}
