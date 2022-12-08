{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "spotify";

  version = rec {
    aarch64-darwin = "1.0.0";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-HnjLgBjLzSRQNHqBLwHFljcJqEPveRTV8GDPc0RqoaY=";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  srcs =
    let base = "https://download.scdn.co/SpotifyInstaller.zip";
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
    description = "Spotify";
    homepage = "https://spotify.com";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Spotify.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Spotify.app
      cp -R . $out/Applications/Spotify.app
      runHook postInstall
    '';
  };
in
darwin

