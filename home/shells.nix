{ config, pkgs, lib, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;
  inherit (lib) mkAfter;
  # usefull when want to write bin bash
  # n = pkgs.writers.writeBash "n" ''
  #     while getopts p flag
  #   do
  #       case "${flag}" in
  #           p) nix develop "my#$1" ${OPTARG};;
  #           *) nix develop "my#$1" -c $SHELL;;
  #       esac
  #   done
  # '';
  shellAliases = with pkgs;
    {
      # Nix related
      nclean = "nix-collect-garbage && nix-collect-garbage -d";
      drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
      drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
      psc0 = "nix build ${nixConfigDirectory}#darwinConfigurations.M1.system --json | jq -r '.[].outputs | to_entries[].value' ";
      #psc1 = "nix build ${nixConfigDirectory}#darwinConfigurations.eR17.system --json | jq -r '.[].outputs | to_entries[].value' | cachix push r17";

      # lenv show list generations aka list build version
      # senv switch generation <number>
      # denv delete generation <number>
      # renv rollback to previous version number
      # param: <GENEREATION_NUMBER> 
      # run lenv before if you want to see <GENEREATION_NUMBER>
      lenv = "nix-env --list-generations";
      senv = "nix-env --switch-generation";
      denv = "nix-env --delete-generations";
      doenv = "denv old";
      renv = "nix-env --rollback";
      # is equivalent to: nix build --recreate-lock-file
      flakeup-all = "nix flake update ${nixConfigDirectory}";
      # example: 
      # $ flakeup home-manager
      flakeup = "nix flake lock ${nixConfigDirectory} --update-input";
      nb = "nix build";
      ndp = "nix develop";
      nf = "nix flake";
      nr = "nix run";
      ns = "nix-shell";
      nq = "nix search";
      # Cryptography
      age = "${rage}/bin/rage";

      # Shell related
      e = "nvim";
      grep = "${ripgrep}/bin/rg";
      c = "z";
      cc = "zi";
      # Others
      p = "ping";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "${bat}/bin/bat";
      du = "${du-dust}/bin/dust";
      git = "${git}/bin/git";
      pullhead = "git pull origin (git rev-parse --abbrev-ref HEAD)";
      plh = "pullhead";
      pushhead = "git push origin (git rev-parse --abbrev-ref HEAD)";
      psh = "pushhead";
      gi = "gitignore";
      g = "git";
      gtemp = "git commit -m \"temp\" --no-verify";
      gf = "git flow";
      gl = "git log --graph --oneline --all";
      gll = "git log --oneline --decorate --all --graph --stat";
      gld = "git log --oneline --all --pretty=format:\"%h%x09%an%x09%ad%x09%s\"";
      gls = "gl --show-signature";
      gfa = "git fetch --all";
      grc = "git rebase --continue";
      #gti = "gitui";
      #lg = "lazygit";
      rm = "rm -i";
      run-ovpn = "sudo /Library/Frameworks/OpenVPNConnect.framework/Versions/Current/usr/sbin/ovpnagent";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

      # Development
      # docker = "${pkgs.podman}/bin/podman";
      # docker-compose = "${pkgs.podman-compose}/bin/podman-compose";
    };
in
{
  home = with pkgs;{
    shellAliases = shellAliases;
    sessionPath = [
      "$HOME/.yarn/bin"
    ];
    sessionVariables = {
      RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";
    };
    packages = with fishPlugins;[
      thefuck
      # https://github.com/franciscolourenco/done
      done
      # use babelfish than foreign-env
      foreign-env
      # https://github.com/wfxr/forgit
      forgit
      # Paired symbols in the command line
      pisces
    ];
  };

  xdg.configFile."fish/conf.d/plugin-git-now.fish".text = mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
  '';

  programs = {
    # jump like `z` or `fasd` 
    zoxide.enable = true;
    dircolors.enable = true;
    go.enable = true;
    # Fish Shell (Default shell)
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
    fish = {
      enable = true;
      # Fish plugins 
      # See: 
      # https://github.com/NixOS/nixpkgs/tree/90e20fc4559d57d33c302a6a1dce545b5b2a2a22/pkgs/shells/fish/plugins 
      # for list available plugins built-in nixpkgs
      plugins = with pkgs.fishPlugins;[
        {
          name = "nix-env";
          src = pkgs.fetchFromGitHub {
            owner = "lilyball";
            repo = "nix-env.fish";
            rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
            sha256 = "069ybzdj29s320wzdyxqjhmpm9ir5815yx6n522adav0z2nz8vs4";
          };
        }
        {
          name = "thefuck";
          src = pkgs.fetchFromGitHub
            {
              owner = "oh-my-fish";
              repo = "plugin-thefuck";
              rev = "6c9a926d045dc404a11854a645917b368f78fc4d";
              sha256 = "1n6ibqcgsq1p8lblj334ym2qpdxwiyaahyybvpz93c8c9g4f9ipl";
            };
        }
      ];

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        # FIXME
        # use-nix = ''
        #   ${pkgs.babelfish} < $HOME/.config/direnv/lib/use_nix-env.sh | source
        #   use_nix-env $argv
        # '';
        nd = ''
          nix develop ${nixConfigDirectory}#$argv[1] -c $SHELL
        '';
        rpkgjson = ''
          ${pkgs.nodejs}/bin/node -e "console.log(Object.entries(require('./package.json').$argv[1]).map(([k,v]) => k.concat(\"@\").concat(v)).join(\"\n\") )"
        '';

        fixgpg = ''
          killall gpg-agent && 
          gpg-agent --daemon &&
          git config --global gpg.program "$(which gpg)" && 
          git config --global user.signingkey $argv[1]
        '';

        # Get PEM Cert from website using openssl
        get-cert = ''
          openssl s_client -showcerts -connect $argv[1] </dev/null | sed -n -e "/-.BEGIN/,/-.END/ p" > $argv[2]
        '';
      };

      interactiveShellInit = ''
        ${pkgs.thefuck}/bin/thefuck --alias | source

        # Fish color
        set -U fish_color_command 6CB6EB --bold
        set -U fish_color_redirection DEB974
        set -U fish_color_operator DEB974
        set -U fish_color_end C071D8 --bold
        set -U fish_color_error EC7279 --bold
        set -U fish_color_param 6CB6EB
        set fish_greeting
      '';
    };

    # Fish prompt and style
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
        };
      };
    };
  };
}
