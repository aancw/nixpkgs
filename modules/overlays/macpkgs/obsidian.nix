{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "obsidian";

  version = rec {
    aarch64-darwin = "1.0.3";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-DYF9fEpZaP4tD/eeZAegDahR7UZyroqNB9bn2U7sgXs=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}-universal.dmg";
    in
    rec {
      aarch64-darwin = {
        url = "${base}";
        sha256 = sha256;
      };
      x86_64-darwin = aarch64-darwin;
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "Obsidian";
    homepage = "https://obsidian.md";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Obsidian.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Obsidian.app
      cp -R . $out/Applications/Obsidian.app
      runHook postInstall
    '';
  };
in
darwin

