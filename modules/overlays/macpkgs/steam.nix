{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "steam";

  version = rec {
    aarch64-darwin = "1.0.0";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-X1VnDJGv02A6ihDYKhedqQdE/KmPAQZkeJHudA6oS6M=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://cdn.akamai.steamstatic.com/client/installer/steam.dmg";
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
    description = "Steam";
    homepage = "https://store.steampowered.com/";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Steam.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Steam.app
      cp -R . $out/Applications/Steam.app
      runHook postInstall
    '';
  };
in
darwin

