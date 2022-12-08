{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "macs-fan-control";

  version = rec {
    aarch64-darwin = "1.5.14";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-mU4IExXwuRr6aSDLg4C0ICjzlPXAulqzrFP0/Dezzf8=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://crystalidea.com/downloads/macsfancontrol.zip";
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
    description = "Macs Fan Control";
    homepage = "https://crystalidea.com/macs-fan-control";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip ];

    sourceRoot = "Macs Fan Control.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Macs Fan Control.app
      cp -R . $out/Applications/Macs Fan Control.app
      runHook postInstall
    '';
  };
in
darwin

