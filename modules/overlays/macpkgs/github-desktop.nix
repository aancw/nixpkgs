{ lib
, stdenv
, fetchurl
, undmg
,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "github-desktop";

  version = rec {
    aarch64-darwin = "3.1.2";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  versionCommit = rec {
    aarch64-darwin = "${version}-7cd66717";
    x86_64-darwin = aarch64-darwin;
  }.${system} or throwSystem;

  sha256 = rec {
    aarch64-darwin = "sha256-RyGUt5nlpGRLI8SfT0rgzoV16glB2EZetcPcpNP63X0=";
    x86_64-darwin = "sha256-pzzBBsiY16+C3nopEfY/llnco8PCsm62erglmgleCtc=";
  }.${system} or throwSystem;

  cpu = rec {
    aarch64-darwin = "arm64";
    x86_64-darwin = "x64";
  }.${system} or throwSystem;

  srcs =
    let base = "https://desktop.githubusercontent.com/github-desktop/releases";
    in
    rec {
      aarch64-darwin = {
        url = "${base}/${versionCommit}/GitHubDesktop-arm64.zip";
        sha256 = sha256;
      };
      x86_64-darwin = {
        url = "${base}/${versionCommit}/GitHubDesktop-x64.zip";
        sha256 = sha256;
      };
    };

  src = fetchurl (srcs.${system} or throwSystem);

  meta = with lib; {
    description = "GitHub Desktop";
    homepage = "https://desktop.github.com";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Github Desktop.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Github Desktop.app
      cp -R . $out/Applications/Github Desktop.app
      runHook postInstall
    '';
  };
in
darwin

