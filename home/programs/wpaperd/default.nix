{ config, lib, ...}:
with lib;
{
  config = mkIf config.hm.hyprland.enable {
    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "30m";
          mode = "center";
          sorting = "random";
          transition-time = "1000";
        };
        any = {
          path = "${config.home.homeDirectory}/Pictures/wallpapers";
        };
      };
    };
  };

}