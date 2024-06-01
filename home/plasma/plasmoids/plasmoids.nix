{ pkgs, ... }:


let
  basePlasmoidDir = "$out/share/plasma/plasmoids";
in
{
  windowTitleApplet = pkgs.stdenv.mkDerivation {
    pname = "window-title-applet";
    version = "0.5.5";

    src = pkgs.fetchFromGitHub {
      owner = "dhruv8sh";
      repo = "plasma6-window-title-applet";
      rev = "6d6b939";
      sha256 = "sha256-dfJcRbUubv3/1PAWCFtNWzc8nyIcgTW39vryFLOOqzs=";
    };

    installPhase = ''
      mkdir -p ${basePlasmoidDir}/org.kde.windowtitle
      cp -rf * ${basePlasmoidDir}/org.kde.windowtitle
    '';
  };

  windowButtonsApplet = import ./windowButtons.nix;
}
