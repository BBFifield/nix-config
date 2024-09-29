{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.hm.gnome-shell = {
    enable = mkEnableOption "Enable Gnome-Shell packages.";
  };
  config = mkIf config.hm.gnome-shell.enable {
    home.packages = with pkgs; [
      gnome-builder
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
    ];
  };
}
