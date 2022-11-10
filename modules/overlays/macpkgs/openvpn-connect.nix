{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "openvpn-connect";

  version = rec {
    aarch64-darwin = "3.4.0";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-GsgQTrXQ3NnowEkPbD4wyPxWReZAtMPsMs9MLlBveJY=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://swupdate.openvpn.net/downloads/connect";
    let r_number = "4506";
    in
    rec {
      aarch64-darwin = {
        url = "${base}/openvpn-connect-${version}.${r_number}_signed.dmg";
        sha256 = sha256;
      };
      x86_64-darwin = aarch64-darwin;
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "OpenVPN Connect for macOS";
    homepage = "https://openvpn.net/";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "OpenVPN Connect.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/OpenVPN Connect.app
      cp -R . $out/Applications/OpenVPN Connect.app
      runHook postInstall
    '';
  };
in
darwin

