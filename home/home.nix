{ pkgs, lib, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  plasmoidPkgs = (pkgs.callPackage ./programs/plasma/plasmoids/plasmoids.nix { });

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    discord
    _1password-gui
    vscode
    arduino-ide
  ];

in {

  imports = lib.concatMap import [ ./programs ];

  programs.home-manager.enable = true;

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
