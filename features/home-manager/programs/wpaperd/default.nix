{
  config,
  lib,
  ...
}:
with lib; {
  options.hm.wpaperd = {
    enable = mkEnableOption "Enable wpaperd.";
  };

  config = mkIf config.hm.wpaperd.enable {
    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          duration = "30m";
          mode = "center";
          sorting = "random";
          transition-time = "1000";
          transition = {
            hexagonalize = {};
          };
        };
        any = {
          path = "${config.home.homeDirectory}/Pictures/wallpapers";
        };
      };
    };
  };
}
