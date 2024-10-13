{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.ironbar;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;

  hotloadSubmodule = import ../../../submodules {inherit lib;};
in {
  options.hm.ironbar = {
    enable = mkEnableOption "Enable ironbar statusbar.";
    hotload = hotloadSubmodule;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      swaynotificationcenter
    ];

    programs.ironbar = {
      enable = true;
      systemd = true;
      config = "";
      style =
        if config.hm.enableMutableConfigs
        then ""
        else ''${builtins.readFile ./config/style.css}'';
    };

    xdg.configFile."ironbar".source =
      if config.hm.enableMutableConfigs
      then mkOutOfStoreSymlink "${config.hm.projectPath}/bars/ironbar/config"
      else ./config/config.corn;
    /*
      home.packages = with pkgs; [
      playerctl
      swaynotificationcenter
    ];

    programs.ironbar = mkMerge [
      {
        enable = true;
        systemd = true;
        config = "";
      }
      (mkIf (config.hm.enableMutableConfigs) {
        style = "";
      })
      (mkIf (!config.hm.enableMutableConfigs) {
        style = ''${builtins.readFile ./config/style.css}'';
      })
    ];

    xdg.configFile."ironbar" = mkMerge [
      (mkIf (config.hm.enableMutableConfigs) {
        source = mkOutOfStoreSymlink "${config.hm.projectPath}/ironbar/config";
      })
      (mkIf (!config.hm.enableMutableConfigs) {source = ./config/config.corn;})
    ];
    */
  };
}
