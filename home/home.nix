{ pkgs, lib, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  plasmoidPkgs = (pkgs.callPackage ./packages/plasmoids/plasmoids.nix {});
  klassy = (pkgs.kdePackages.callPackage ./packages/klassy/klassy.nix {});

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    discord
    _1password-gui
    vscode
    shellcheck
    arduino-ide
    application-title-bar
  ];

in {

  imports = lib.concatMap import [ ./programs ];

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages
      = defaultPkgs
      ++ (with plasmoidPkgs;
      [
        gnomeDesktopIndicatorApplet
        windowTitleApplet
        windowButtonsApplet
        panelColorizer
      ])
      ++ [klassy];
    };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

}
