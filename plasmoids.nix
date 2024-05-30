{ pkgs, ... }:


let
  basePlasmoidDir = "$out/share/plasma/plasmoids";
in
{
  /*advanced_radio_player = pkgs.stdenv.mkDerivation {
    name = "plasma-advanced-radio";
    src = pkgs.fetchurl {
      url = "https://github.com/marius851000/ricenur-data/raw/b89ae5f5166c955f181eb31953e12b238b29c35d/org.kde.plasma.advancedradio.tar.gz";
      sha256 = "FSXDfxuGfjnOOurrg9Uo1uRYBb3ruzI/wvsvpfmvD5M=";
    };

    installPhase = ''
      mkdir -p ${base_plasmoid_dir}/org.kde.plasma.advancedradio
      cp -rf * ${base_plasmoid_dir}/org.kde.plasma.advancedradio
    '';
  };*/

  window-title-applet = pkgs.stdenv.mkDerivation {
    name = "Window Title";

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

  /*applet-window-buttons = pkgs.stdenv.mkDerivation {
    name = "Window Buttons"

    src = pkgs.fetchFromGitHub {
      owner = "moodyhunter";
      repo = "applet-window-buttons6";
      rev = "3263828";
      sha256 = "sha256-dfJcRbUubv3/1PAWCFtNWzc8nyIcgTW39vryFLOOqzs=";
    };

    installPhase = ''
      mkdir -p ${basePlasmoidDir}/org.kde.windowbuttons
      cp -rf * ${basePlasmoidDir}/org.kde.windowbuttons
    '';
  };*/


}
