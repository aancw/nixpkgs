{ lib
, stdenv
, fetchurl
, libarchive
, p7zip
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

  rNumber = rec {
    aarch64-darwin = "4506";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-GsgQTrXQ3NnowEkPbD4wyPxWReZAtMPsMs9MLlBveJY=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://swupdate.openvpn.net/downloads/connect";
    in
    rec {
      aarch64-darwin = {
        url = "${base}/openvpn-connect-${version}.${rNumber}_signed.dmg";
        sha256 = sha256;
      };
      x86_64-darwin = {
        url = "${base}/openvpn-connect-${version}.${rNumber}_signed.dmg";
        sha256 = sha256;
      };
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "OpenVPN Connect for macOS";
    homepage = "https://openvpn.net/";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    sourceRoot = rec {
      aarch64-darwin = "OpenVPN_Connect_3_4_0(4506)_arm64_Installer_signed.pkg";
      x86_64-darwin  = "OpenVPN_Connect_3_4_0(4506)_x86_64_Installer_signed.pkg";
    }.${system} or throwSystem;

    dontBuild = true;
    nativeBuildInputs = [ libarchive p7zip ];

    unpackPhase = ''
      7z x $src
      bsdtar -xf Payload~
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 usr/local/bin/mysides -t $out/bin
      runHook postInstall
    '';
  };
in
darwin

