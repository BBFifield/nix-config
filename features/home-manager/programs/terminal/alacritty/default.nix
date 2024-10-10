{
  config,
  pkgs,
  lib,
  ...
}: let
  family = "JetBrainsMono Nerd Font";
  cfg = config.hm.theme;
in {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        import = lib.mkMerge [
          (lib.mkIf (cfg.colorScheme.name == "catppuccin") [
            pkgs.alacritty-theme."catppuccin_${cfg.colorScheme.variant}"
          ])
          (lib.mkIf (cfg.colorScheme.name == "dracula") [
            pkgs.alacritty-theme.dracula
          ])
        ];
        font = {
          size = 11.0;
          bold = {
            inherit family;
            style = "Bold";
          };
          bold_italic = {
            inherit family;
            style = "Bold Italic";
          };
          italic = {
            inherit family;
            style = "Italic";
          };
          normal = {
            inherit family;
            style = "Regular";
          };
        };
        window = {
          opacity = 0.9;
        };
      };
    };
  };
}
