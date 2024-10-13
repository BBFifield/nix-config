{
  config,
  lib,
  ...
}: let
  cfg = config.hm.theme.colorscheme;
  colorschemes = import ./colorschemeInfo.nix;
  colorschemeEnums = lib.attrNames colorschemes;
  defaultScheme = lib.elemAt colorschemeEnums 0;
  defaultVariant = lib.elemAt (lib.attrNames colorschemes.${defaultScheme}.variants) 0;
  colorschemeSubmodule = with lib;
    types.submodule {
      options = {
        name = mkOption {
          type = types.enum colorschemeEnums;
          default = defaultScheme;
        };
        variant = mkOption {
          type = types.str;
          default = defaultVariant;
        };
        props = mkOption {
          type = types.attrs;
          default = colorschemes.${defaultScheme}.variants.${defaultVariant};
        };
        cognates = mkOption {
          type = types.attrs;
          default = colorschemes.${defaultScheme}.cognates defaultVariant;
        };
      };
    };
in {
  options.hm.theme = with lib; {
    colorscheme = mkOption {
      type = colorschemeSubmodule;
    };
  };

  config = {
    hm.theme.colorscheme.props = let
      variantEnums = lib.attrNames colorschemes.${cfg.name}.variants;
    in
      assert lib.assertOneOf "variant" cfg.variant variantEnums; colorschemes.${cfg.name}.variants.${cfg.variant};

    hm.theme.colorscheme.cognates = colorschemes.${cfg.name}.cognates cfg.variant;
  };
}
