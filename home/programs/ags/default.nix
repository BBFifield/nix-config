{ pkgs, config, lib, ... }:
with lib;
{
  options.hm.ags = {
    enable = mkEnableOption "Enable AGS bar/panel";
  };
  config = mkIf (config.hm.ags.enable) {
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = null;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        sassc
        webkitgtk
        accountsservice
      ];
    };
  };
}