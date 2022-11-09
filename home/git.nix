{ config, pkgs, ... }:

let
  personal = {
    name = "Aan";
    email = "me@petruknisme.com";
    signingKey = "6EAB0E2374156E98";
  };
in
{
  programs.git.enable = true;

  programs.git.aliases = {
    a = "add";
    c = "clone";
    cfd = "clean -fd";
    ca = "commit --amend";
    can = "commit --amend --no-edit";
    r = "rebase";
    ro = "rebase origin/master";
    rc = "rebase --continue";
    ra = "rebase --abort";
    ri = "rebase -i";
    # need to install vim-conflicted
    res = "!nvim +Conflicted";
    # use for resolve conflicted
    # accept-ours
    aco = "!f() { git checkout --ours -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";
    # accept-theirs
    ace = "!f() { git checkout --theirs -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";
    branches = "branch --sort=-committerdate --format='%(HEAD)%(color:yellow) %(refname:short) | %(color:bold red)%(committername) | %(color:bold green)%(committerdate:relative) | %(color:blue)%(subject)%(color:reset)' --color=always";
    bs = "branches";
    fa = "fetch --all";
  };

  programs.git.extraConfig = {
    gpg.program = "gpg";
    rerere.enable = true;
    commit.gpgSign = true;
    pull.ff = "only";
    diff.tool = "vimdiff";
    difftool.prompt = false;
    merge.tool = "vimdiff";
    url = {
      "git@gitlab.com" = {
        insteadOf = "https://gitlab.com";
      };
    };
  };

  programs.git.includes = [
    {
      condition = "gitdir:~/Documents/GitHub";
      contents.user = personal;
    }

    {
      condition = "gitdir:~/.config/nixpkgs/";
      contents.user = personal;
    }
  ];


  ### git tools
  ## github cli
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
  programs.gh.settings.aliases = {
    co = "pr checkout";
    pv = "pr view";
  };
}
