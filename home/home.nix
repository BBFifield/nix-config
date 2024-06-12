{ pkgs, lib, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  plasmoidPkgs = (pkgs.callPackage ./plasma/plasmoids/plasmoids.nix { });
  #windowButtonsApplet = (pkgs.kdePackages.callPackage ../windowButtonsPlasmoid.nix {});

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    home-manager
    discord
    _1password-gui
    vivaldi
    vivaldi-ffmpeg-codecs
    vscode
  ];

in {

  imports = lib.concatMap import [ ./programs ./plasma ];

  #programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages = defaultPkgs ++ (with plasmoidPkgs; [
      gnomeDesktopIndicatorApplet
      windowTitleApplet
      windowButtonsApplet
    ]);
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

}
