{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.desktop.nautilus;
in
  with lib; {
    options.nixos.desktop.nautilus = {
      enable = mkEnableOption "Enable Nautilus file manager.";
    };
    config = mkIf cfg.enable {
      # Some reason this causes nautilus to require copying an item twice in order to be able to paste
      /*
        programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "alacritty";
      };
      */

      environment = {
        # sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
        # pathsToLink = [
        #   "/share/nautilus-python/extensions"
        #  ];

        systemPackages = with pkgs; [
          nautilus
          #   nautilus-python
        ];
      };
    };
  }
