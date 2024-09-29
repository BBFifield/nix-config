{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.ironbar;
in {
  options.hm.ironbar = {
    enable = mkEnableOption "Enable ironbar statusbar.";
  };

  config = mkIf cfg.enable {
    programs.ironbar = {
      enable = false;
      #package = pkgs.ironbar;
    };
  };
}
