{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

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
in {
  imports = (lib.concatMap import [../../home-manager/programs]) ++ [../../home-manager/fonts];

  hm =
    lib.optionalAttrs (osConfig.desktop.session == "plasma") {
      firefox = {
        enable = true;
        style = "plasma";
      };
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktop.session == "gnome") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      gnome-shell.enable = true;
      dconf.enable = true;
    }
    // lib.optionalAttrs (osConfig.desktop.session == "hyprland") {
      firefox = {
        enable = true;
        style = "gnome";
      };
      dconf.enable = true;
      #gBar.enable = true;
      hyprland.enable = true;
      # ags.enable = true;
    };

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
