{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

  iconPkgs = pkgs.callPackage ../pkgs/icons {};
  plasmoidPkgs = pkgs.callPackage ../pkgs/plasmoids/plasmoids.nix {};
  klassy = pkgs.kdePackages.callPackage ../pkgs/klassy/klassy.nix {};

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
      kde-rounded-corners
    ]
    ++ (with plasmoidPkgs; [
      gnomeDesktopIndicatorApplet
      windowTitleApplet
      windowButtonsApplet
      panelColorizer
    ])
    ++ (with iconPkgs; [breezeChameleon])
    ++ [klassy];

  gnomePkgs = with pkgs; [
    adw-gtk3
    gnome-builder
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    tela-icon-theme
    orchis-theme
  ]
  ++ (with iconPkgs; [breezeXcursor]); #For the cursor

  hyprlandPkgs = with pkgs; [
    adw-gtk3
    alacritty
    nautilus
    nwg-bar
    nwg-look
    nwg-dock-hyprland
    nwg-displays
    nwg-launchers
    elegant-sddm
    alacritty-theme
    tela-icon-theme
    orchis-theme
  ];

in {
  imports = lib.concatMap import [./programs];

  hm =
    lib.optionalAttrs (osConfig.desktopEnv.choice == "plasma") {

      firefox = {
        enable = true;
        style = "plasma";
      };
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktopEnv.choice == "gnome") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      dconf.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktopEnv.choice == "hyprland") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      hyprland.enable = true;
    };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs
      ++ lib.optionals (osConfig.desktopEnv.choice == "plasma")
      plasmaPkgs
      ++ lib.optionals (osConfig.desktopEnv.choice == "gnome")
      gnomePkgs
      ++ lib.optionals (osConfig.desktopEnv.choice == "hyprland")
      hyprlandPkgs;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
