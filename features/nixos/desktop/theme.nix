# Use command "fc-list : family style" to see a list of fonts on your system.
{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop.theme;

  nfAttrs = {
    "VictorMono" = {name = "VictorMono Nerd Font";};
    "IosevkaTerm" = {name = "IosevkaTerm Nerd Font";};
    "JetBrainsMono" = {name = "JetBrainsMono Nerd Font";};
    "Iosevka" = {name = "Iosevka Nerd Font";};
    "RobotoMono" = {name = "RobotoMono Nerd Font";};
    "CascadiaCode" = {name = "CaskaydiaCove Nerd Font Mono";};
    "FiraCode" = {name = "FiraCode Nerd Font";};
  };

  nfToFetch = builtins.attrNames nfAttrs;

  nfEnums = with builtins; attrValues (mapAttrs (name: value: value.name) nfAttrs);

  fontsSubmodule = types.submodule {
    options = {
      defaultMonospace = mkOption {
        type = types.enum nfEnums;
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
      name = mkOption {
        type = types.str;
        default = "BreezeX-Dark";
      };
    };
  };
in {
  options.nixos.desktop.theme = {
    fonts = mkOption {
      type = fontsSubmodule;
      default = "JetBrainsMono";
    };
    cursorTheme = mkOption {
      type = cursorSubmodule;
      default = {
        size = 28;
        name = "BreezeX-Dark";
      };
    };
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace];
    };

    environment.systemPackages = with pkgs;
      [
        (nerdfonts.override {
          fonts = nfToFetch;
        })
        iosevka
      ]
      ++ [pkgs.icons.breezeXcursor]; # custom # Needs to be installed system-wide so sddm has access to it;
  };
}
