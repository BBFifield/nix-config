{
  config,
  pkgs,
  lib,
  ...
}: let
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
    programs.yazi = let
      cfg = config.hm.theme.colorScheme;
    in {
      enable = true;
      enableBashIntegration = true;
      flavors = lib.mkMerge [
        (lib.mkIf (cfg.name == "catppuccin") {
          "catppuccin-${cfg.variant}" = "${pkgs.yazi-flavors}/catppuccin-${cfg.variant}.yazi";
        })
      ];
      settings = {
        manager = {
          show_hidden = true;
        };
      };
      theme = {
        flavor.use = lib.mkMerge [
          (lib.mkIf (cfg.name == "catppuccin") "catppuccin-${cfg.variant}")
        ];
      };
    };
  };
}
