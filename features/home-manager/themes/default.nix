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
  gtkThemeEnums = builtins.attrNames gtkThemeAttrs;
  defaultGtkTheme = builtins.elemAt gtkThemeEnums 0;
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
  nfToFetch = builtins.attrNames nfAttrs;
  nfEnums = with builtins; attrValues (mapAttrs (name: value: value.name) nfAttrs);
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
  cursorThemeEnums = builtins.attrNames cursorThemeAttrs;
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

  colorSchemes = import ./colorSchemes.nix;
  colorSchemeEnums = builtins.attrNames colorSchemes;
  defaultScheme = builtins.elemAt colorSchemeEnums 0;
  defaultVariant = builtins.elemAt (builtins.attrNames colorSchemes.${defaultScheme}.variant) 0;
  colorSchemeSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum colorSchemeEnums;
        default = defaultScheme;
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = defaultVariant;
      };
      props = lib.mkOption {
        type = lib.types.attrs;
        default = colorSchemes.${defaultScheme}.variant.${defaultVariant};
      };
    };
  };
in {
  options.hm.theme = with lib; {
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
      default = {
        name = defaultGtkTheme;
        package = pkgs.${gtkThemeAttrs.${defaultGtkTheme}};
      };
    };
    iconTheme = mkOption {
      type = types.enum iconThemeEnums;
      default = "MoreWaita";
    };
    fonts = mkOption {
      type = fontsSubmodule;
      default = "JetBrainsMono";
    };
    cursorTheme = mkOption {
      type = cursorSubmodule;
      default = {
        size = 24;
        name = "BreezeX-Dark";
        package = pkgs.${cursorThemeAttrs."BreezeX-Dark"}; #pkgs.icons.breezeXcursor;
      };
    };
    colorScheme = mkOption {
      type = colorSchemeSubmodule;
      default = {
        name = defaultScheme;
        variant = defaultVariant;
        props = colorSchemes.${defaultScheme}.variant.${defaultVariant};
      };
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

    hm.theme.colorScheme.props = let
      variantEnums = lib.attrNames colorSchemes.${cfg.colorScheme.name}.variant;
    in
      assert lib.assertOneOf "variant" cfg.colorScheme.variant variantEnums; colorSchemes.${cfg.colorScheme.name}.variant.${cfg.colorScheme.variant};
  };
}
