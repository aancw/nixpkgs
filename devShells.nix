{ pkgs, ... }:

let
  inherit (pkgs) stdenv;
  inherit (pkgs.lib) singleton;
in

with pkgs;

rec {

  # }}}

  # Rust 🦀 development environments ------------------- {{{
  # `nix develop my#rust`
  /* rust = mkShell {
    buildInputs = [
      (rust-bin.stable.latest.minimal.override {
        extensions = [ "rustc" ];
      })
    ];
  };
 */
  # `nix develop my#rust-wasm`  
  rust-wasm = mkShell {
    buildInputs = [
      (rust-bin.stable.latest.minimal.override {
        extensions = [ "rustc" ];
        targets = [ "wasm32-wasi" ];
      })
    ];
    packages = [
      rustfmt
    ];
  };

  # }}}

  # Lua development environments ---------------------- {{{

  lua = mkShell {
    buildInputs = [
      luajit
      luajitPackages.luafun
    ];
  };

  go = mkShell {
    name = "go-environments";
    buildInputs = [
      go
    ];
  };

  # }}}
}

# vim: foldmethod=marker
