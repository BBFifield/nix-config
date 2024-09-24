{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.yazi;
in {
  /*
    options.hm.yazi = {
    enable = mkEnableOption "Enable Yazi, the terminal file manager.";
  };
  */
  config = {
    home.packages = with pkgs; [
      ueberzugpp
    ];
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      settings = {
      };
    };
  };
}
