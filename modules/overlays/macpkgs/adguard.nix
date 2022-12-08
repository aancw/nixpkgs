{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "adguard";

  version = rec {
    aarch64-darwin = "2.9.0";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-tGv95fgisjbUyPaKdVYh8+fXrNcu6wDlR5qQI1kebrw=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://download.adguard.com/d/18675/AdGuardInstaller.dmg";
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
    description = "AdGuard for Mac";
    homepage = "https://adguard.com/";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Adguard.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Adguard.app
      cp -R . $out/Applications/Adguard.app
      runHook postInstall
    '';
  };
in
darwin

