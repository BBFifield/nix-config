{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

 # iconPkgs = pkgs.callPackage ../pkgs/icons {};
  #plasmoidPkgs = pkgs.callPackage ../pkgs/plasmoids/plasmoids.nix {};
  #klassy = pkgs.kdePackages.callPackage ../pkgs/klassy/klassy.nix {};

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

  gnomePkgs = with pkgs; [
    adw-gtk3
    gnome-builder
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    tela-icon-theme
    orchis-theme
  ]
  ++ (icons.breezeXcursor); #For the cursor

in {
  imports = (lib.concatMap import [./programs]) ++ [./fonts];

  hm =
    lib.optionalAttrs (osConfig.desktopEnv.session == "plasma") {

      firefox = {
        enable = true;
        style = "plasma";
      };
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktopEnv.session == "gnome") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      dconf.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktopEnv.session == "hyprland") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      gBar.enable =true;
      hyprland.enable = true;
      ags.enable = true;
    };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs
      ++ lib.optionals (osConfig.desktopEnv.session == "gnome")
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
