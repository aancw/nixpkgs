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
      asciinema # screen record
      # glab # gitlab cli
      # nodePackages.svg-term-cli
      # nodePackages."@napi-rs/cli"
      # nodePackages.mrm

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
      gcc
      # yarn # currently defined in devShell.nix
      tokei
      # google-cloud-sdk
      # nodejs-16_x
      # gitlab-runner
      comby
      python3
      ipython
      pkg-config
      mob
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
      (zoom-us.overrideAttrs
        (oldAttrs: rec
        {
          src = lib.optionals pkgs.stdenv.isDarwin fetchurl {
            url = "https://zoom.us/client/${oldAttrs.version}/Zoom.pkg?archType=arm64";
            sha256 = "sha256-btp7y/pmxr2qUrwhMEP2cqW5aTyy9GDPvkXaH/cYv5s=";
          };
        }
        )
      )
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
        xbar
        rectangle
        cocoapods
        m-cli # useful macOS CLI commands
        xcode-install
        telegram
        iriun-webcam
        clipy
        # googlechrome
      ];
}
