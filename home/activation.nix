{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # home.activation = {
  #
  #   copyApplications =
  #     lib.hm.dag.entryAfter [ "writeBoundary" ]
  #       (lib.optionalString (pkgs.stdenv.isDarwin)
  #         (
  #           let
  #             apps = pkgs.buildEnv {
  #               name = "home-manager-applications";
  #               paths = config.home.packages;
  #               pathsToLink = "/Applications";
  #             };
  #           in
  #           ''
  #             # Set up applications.
  #             echo "setting up /Applications/Nix Apps..." >&2
  #
  #             ourLink () {
  #               local link
  #               link=$(readlink "$1")
  #               [ -L "$1" ] && [ "''${link#*-}" = 'system-applications/Applications' ]
  #             }
  #
  #             # Clean up for links created at the old location in HOME
  #             if ourLink ~/Applications; then
  #               rm ~/Applications
  #             elif ourLink ~/Applications/'Nix Apps'; then
  #               rm ~/Applications/'Nix Apps'
  #             fi
  #
  #             if [ ! -e '/Applications/Nix Apps' ] \
  #               || ourLink '/Applications/Nix Apps'; then
  #               ln -sfn ${apps}/Applications '/Applications/Nix Apps'
  #             else
  #               echo "warning: /Applications/Nix Apps is not owned by nix-darwin, skipping App linking..." >&2
  #             fi
  #           ''
  #         )
  #       )
  #   ;
  #
    # this activation for update nix-index-database by system (darwin|linux)
    # nix-index-database it's use for "comma" - run without install
  #   updateNixIndexDB = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.optionalString (config.programs.nix-index.enable) ''
  #     filename="index-x86_64-$(uname | tr A-Z a-z)"
  #     cacheNixIndex="$HOME/.cache/nix-index"
  #     if [ ! -d "$cacheNixIndex"]; then 
  #       mkdir -p $cacheNixIndex
  #     fi
  #
  #     cd $cacheNixIndex
  #     # -N will only download a new version if there is an update.
  #     ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
  #     ln -f $filename files
  #   ''
  #   );
  # };
  #
}
