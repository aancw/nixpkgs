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

  srcs =
    let base = "https://cdn.akamai.steamstatic.com/client/installer/steam.dmg";
    in
    rec {
      aarch64-darwin = {
        url = "${base}";
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
    inherit pname src meta;

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

