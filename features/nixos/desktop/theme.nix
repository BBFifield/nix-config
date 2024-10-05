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
    "FiraCode" = {name = "FiraCode Nerd Font";};
    "VictorMono" = {name = "VictorMono Nerd Font";};
    "IosevkaTerm" = {name = "IosevkaTerm Nerd Font";};
    "JetBrainsMono" = {name = "JetBrainsMono Nerd Font";};
    "Iosevka" = {name = "Iosevka Nerd Font";};
    "RobotoMono" = {name = "RobotoMono Nerd Font";};
    "CascadiaCode" = {name = "CaskaydiaCove Nerd Font Mono";};
  };
  nfToFetch = builtins.attrNames nfAttrs;
  nfEnums = with builtins; attrValues (mapAttrs (name: value: value.name) nfAttrs);

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = builtins.attrNames cursorThemeAttrs;

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
        default = 24;
      };
      name = mkOption {
        type = types.enum cursorThemeEnums;
        default = "BreezeX-Dark";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.icons.breezeXcursor;
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
        size = 24;
        name = "BreezeX-Dark";
        package = pkgs.icons.breezeXcursor;
      };
    };
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace];
    };

    nixos.desktop.theme.cursorTheme.package = let
      pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
    in
      mkPkgName {} pkgs pkgNameParts;

    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = nfToFetch;
      })
      iosevka
    ];
    environment.systemPackages = [cfg.cursorTheme.package]; # custom # Needs to be installed system-wide so sddm has access to it;
  };
}
