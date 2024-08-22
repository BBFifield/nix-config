{
  config,
  lib,
  ...
}:
with lib; {
  options.hm.hyprland.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock.";
  };
  config = mkIf config.hm.hyprland.enable {
    programs.hyprlock = {
      enable = true;
      #https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
      extraConfig = ''
        ${builtins.readFile ./hyprlock.conf}
      '';
    };
  };
}
