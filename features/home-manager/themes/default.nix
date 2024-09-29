{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.theme;

  mkPkgName = let
    getElem = with builtins; count: attr_list: elemAt attr_list ((length attr_list) - count);
  in
    with builtins;
      {count ? 1}: {prefix ? pkgs}: attr_list: (
        if (getElem count attr_list) == (elemAt attr_list 0)
        then (head (lib.attrsets.attrVals [(getElem count attr_list)] prefix))
        else
          (
            head (lib.attrsets.attrVals [(getElem count attr_list)] (mkPkgName {count = count + 1;} {inherit prefix;} attr_list))
          )
      );

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

  iconThemeAttrs = {
    "icons.breezeChameleon" = ''"Breeze-Round-Chameleon Dark Icons"'';
    "morewaita-icon-theme" = "MoreWaita";
    "tela-icon-theme" = "Tela";
    "qogir-icon-theme" = "Qogir";
  };
  iconThemeEnums = builtins.attrValues iconThemeAttrs;

  gtkThemeAttrs = {
    adw-gtk3 = "adw-gtk3";
    adw-gtk3-dark = "adw-gtk3";
    orchis = "orchis-theme";
    Breeze = "kdePackages.breeze";
  };
  gtkThemeEnums = builtins.attrNames gtkThemeAttrs;

  cursorThemeAttrs = {
    "BreezeX-Dark" = "icons.breezeXcursor";
  };
  cursorThemeEnums = builtins.attrNames cursorThemeAttrs;

  gtkThemeSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.enum gtkThemeEnums;
        default = "adw-gtk3-dark";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.adw-gtk3;
      };
    };
  };
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
        type = types.enum cursorThemeEnums;
        default = "BreezeX-Dark";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.${cursorThemeAttrs."BreezeX-Dark"}; #pkgs.icons.breezeXcursor;
      };
    };
  };
in {
  options.hm.theme = {
    gtkTheme = mkOption {
      type = gtkThemeSubmodule;
      default = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk;
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
  };

  config = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [cfg.fonts.defaultMonospace];
    };
    hm.theme.gtkTheme.package = let
      pkgNameParts = lib.splitString "." gtkThemeAttrs.${cfg.gtkTheme.name};
    in
      mkPkgName {} pkgs pkgNameParts;

    hm.theme.cursorTheme.package = let
      pkgNameParts = lib.splitString "." cursorThemeAttrs.${cfg.cursorTheme.name};
    in
      mkPkgName {} pkgs pkgNameParts;

    home.packages = with pkgs; let
      filterByValue = value: attrs: builtins.filter (name: attrs.${name} == value) (builtins.attrNames attrs); # Get icon package to be installed
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
