# Use command "fc-list : family style" to see a list of fonts on your system.
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;

  fontsSubmodule = types.submodule {
    options = {
      defaultMonospace = mkOption {
        type = types.str;
        default = "JetBrainsMono";
      };
    };
  };
  cursorSubmodule = types.submodule {
    options = {
      size = mkOption {
        type = types.ints.positive;
        default = 28;
      };
      theme = mkOption {
        type = types.str;
        default = "BreezeX-Dark";
      };
    };
  };
in {
  options.nixos.desktop = {
    fonts = mkOption {
      type = fontsSubmodule;
      default = "JetBrainsMono";
    };
    cursor = mkOption {
      type = cursorSubmodule;
      default = {
        size = 28;
        theme = "BreezeX-Dark";
      };
    };
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace]; #["FiraCode Nerd Font"];
    };

    environment.systemPackages = with pkgs; [
      (nerdfonts.override {
        fonts = ["VictorMono" "IosevkaTerm" "JetBrainsMono" "Iosevka" "RobotoMono" "CascadiaCode"]; #["Iosevka" "FiraCode" "RobotoMono" "JetBrainsMono" "CascadiaCode"];
      })
      iosevka
    ];
  };
}
