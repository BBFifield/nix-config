{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

  iconPkgs = pkgs.callPackage ./packages/icons {};
  plasmoidPkgs = pkgs.callPackage ./packages/plasmoids/plasmoids.nix {};
  klassy = pkgs.kdePackages.callPackage ./packages/klassy/klassy.nix {};

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

  plasmaPkgs = with pkgs;
    [
      application-title-bar #plasmoid
    ]
    ++ (with plasmoidPkgs; [
      gnomeDesktopIndicatorApplet
      windowTitleApplet
      windowButtonsApplet
      panelColorizer
    ])
    ++ (with iconPkgs; [breezeChameleon breezeXcursor])
    ++ [klassy];

  gnomePkgs = with pkgs; [
    kdePackages.breeze
    adw-gtk3
    gnome-builder
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    tela-icon-theme
    orchis-theme
  ];
in {
  imports = lib.concatMap import [./programs];

  hm =
    lib.optionalAttrs (osConfig.desktopEnv.enable == "plasma") {
      firefox = {
        enable = true;
        style = "plasma";
      };
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktopEnv.enable == "gnome") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      dconf.enable = true;
    };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs
      ++ lib.optionals (osConfig.desktopEnv.enable == "plasma")
      plasmaPkgs
      ++ lib.optionals (osConfig.desktopEnv.enable == "gnome")
      gnomePkgs;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
