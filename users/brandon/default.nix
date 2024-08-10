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
    shellcheck
    arduino-ide
    #lunarvim
  ];
in {
  imports = (lib.concatMap import [../../home-manager/programs]) ++ [../../home-manager/fonts];

  # lib.mergeAttrsList or // do not work here instead of lib.mkMerge because firefox for example, is
  # defined in both the base config and one of the optionals to be merged. The attribute sets only merge nicely if both contain distinct attribute keys,
  # so in this case firefox.enable = false (implied and the default value) from the optional set overrides the earlier declaration. "lib.mkMerge" otoh, merges
  # explicitly declared values and ignores "implied".
  hm = lib.mkMerge [
    {
      firefox.enable = true;
      vscodium.enable = true;
    } (lib.optionalAttrs (osConfig.desktop.session == "plasma") {
      firefox.style = "plasma";
      plasma.enable = true;
      konsole.enable = true;
      klassy.enable = true;
      kate.enable = true;
    }) (lib.optionalAttrs (osConfig.desktop.session == "gnome") {
      firefox.style = "gnome";
      gnome-shell.enable = true;
      dconf.enable = true;
      vscodium.theme = "gnome";
    }) (lib.optionalAttrs (osConfig.desktop.session == "hyprland") {
      firefox.style = "gnome";
      dconf.enable = true;
      #gBar.enable = true;
      hyprland.enable = true;
      #ags.enable = true;
      vscodium.theme = "gnome";
    })];

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
