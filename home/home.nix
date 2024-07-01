{ pkgs, config, lib, desktopEnv, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";

  iconPkgs = (pkgs.callPackage ./packages/icons {});
  plasmoidPkgs = (pkgs.callPackage ./packages/plasmoids/plasmoids.nix {});
  klassy = (pkgs.kdePackages.callPackage ./packages/klassy/klassy.nix {});

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    discord
    _1password-gui
    vscodium
    shellcheck
    arduino-ide
  ];

  plasmaPkgs =
    [ pkgs.application-title-bar ] #plasmoid
    ++ (with plasmoidPkgs;
      [
        gnomeDesktopIndicatorApplet
        windowTitleApplet
        windowButtonsApplet
        panelColorizer
      ])
    ++ (with iconPkgs;
      [ breezeChameleon ])
    ++ [klassy];

  gnomePkgs = with pkgs;
    [
      kdePackages.breeze
      adw-gtk3
      gnome-builder
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
      tela-icon-theme
      orchis-theme
    ];


in {

  imports = (import ./programs {inherit pkgs lib config desktopEnv;}).${desktopEnv};

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs
      ++ lib.optionals (desktopEnv == "plasma6")
        plasmaPkgs
     # ++ lib.optionals (desktopEnv == "gnome")
      #  gnomePkgs
    ;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

}
