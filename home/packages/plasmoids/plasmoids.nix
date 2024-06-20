{ pkgs, ... }:


let
  basePlasmoidDir = "$out/share/plasma/plasmoids";
in
{
  gnomeDesktopIndicatorApplet = pkgs.stdenv.mkDerivation {
    pname = "Ginti";
    version = "0.5";

    src = pkgs.fetchFromGitHub {
      owner = "dhruv8sh";
      repo = "plasma6-desktopindicator-gnome";
      rev = "5ca6507";
      sha256 = "sha256-M47GO8X2NWtjjyK9w1cFkh9XCvho5BvcFDUyF4Q2Oi0=";
    };

    installPhase = ''
      mkdir -p ${basePlasmoidDir}/org.kde.plasma.ginti
      cp -rf * ${basePlasmoidDir}/org.kde.plasma.ginti
    '';
  };

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

  windowButtonsApplet = (pkgs.kdePackages.callPackage ./windowButtons.nix {});
}
