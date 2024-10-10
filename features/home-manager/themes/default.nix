{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.theme;

  iconThemeAttrs = {
    "icons.breezeChameleon" = ''"Breeze-Round-Chameleon Dark Icons"'';
    "morewaita-icon-theme" = "MoreWaita";
    "tela-icon-theme" = "Tela";
    "qogir-icon-theme" = "Qogir";
  };
  iconThemeEnums = lib.attrValues iconThemeAttrs;

  gtkThemeAttrs = {
    adw-gtk3 = "adw-gtk3";
    adw-gtk3-dark = "adw-gtk3";
    orchis = "orchis-theme";
    Breeze = "kdePackages.breeze";
  };
  gtkThemeEnums = lib.attrNames gtkThemeAttrs;
  defaultGtkTheme = lib.elemAt gtkThemeEnums 0;
  gtkThemeSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum gtkThemeEnums;
        default = defaultGtkTheme;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.${gtkThemeAttrs.${defaultGtkTheme}};
      };
    };
  };

  nfAttrs = {
    VictorMono = {name = "VictorMono Nerd Font";};
    IosevkaTerm = {name = "IosevkaTerm Nerd Font";};
    JetBrainsMono = {name = "JetBrainsMono Nerd Font";};
    Iosevka = {name = "Iosevka Nerd Font";};
    RobotoMono = {name = "RobotoMono Nerd Font";};
    CascadiaCode = {name = "CaskaydiaCove Nerd Font Mono";};
    FiraCode = {name = "FiraCode Nerd Font";};
  };
  nfToFetch = lib.attrNames nfAttrs;
  nfEnums = lib.attrValues (lib.mapAttrs (name: value: value.name) nfAttrs);
  fontsSubmodule = lib.types.submodule {
    options = {
      defaultMonospace = lib.mkOption {
        type = lib.types.enum nfEnums;
        default = "JetBrainsMono";
      };
    };
  };

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = lib.attrNames cursorThemeAttrs;
  cursorSubmodule = lib.types.submodule {
    options = {
      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 28;
      };
      name = lib.mkOption {
        type = lib.types.enum cursorThemeEnums;
        default = "BreezeX-Dark";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.${cursorThemeAttrs."BreezeX-Dark"}; #pkgs.icons.breezeXcursor;
      };
    };
  };
in {
  imports = [./colorSchemes.nix {}];

  options.hm.theme = with lib; {
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
    };
    iconTheme = mkOption {
      type = types.enum iconThemeEnums;
    };
    fonts = mkOption {
      type = fontsSubmodule;
    };
    cursorTheme = mkOption {
      type = cursorSubmodule;
    };
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace];
    };
    hm.theme.gtkTheme.package = let
      pkgNameParts = lib.splitString "." gtkThemeAttrs.${cfg.gtkTheme.name};
    in
      lib.mkPkgName {} pkgs pkgNameParts;

    hm.theme.cursorTheme.package = let
      pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
    in
      lib.mkPkgName {} pkgs pkgNameParts;

    home.packages = with pkgs; let
      filterByValue = value: attrs: builtins.filter (name: attrs.${name} == value) (lib.attrNames attrs); # Get icon package to be installed
      iconTheme = pkgs.${builtins.head (filterByValue cfg.iconTheme iconThemeAttrs)};
      dependencies = lib.optionals (cfg.iconTheme == "MoreWaita") [pkgs.adwaita-icon-theme]; #MoreWaita requires Adwaita to also be installed
      iconThemePkgs = [iconTheme] ++ dependencies;
    in
      [cfg.gtkTheme.package]
      ++ iconThemePkgs
      ++ [
        (nerdfonts.override {
          fonts = nfToFetch;
        })
      ]
      ++ [cfg.cursorTheme.package]; # custom # Needs to be installed system-wide so sddm has access to it;
  };
}
