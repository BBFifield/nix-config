{
  config,
  lib,
  ...
}: let
  cfg = config.hm.theme.colorScheme;
  colorSchemes = {
    catppuccin = rec {
      variants = {
        mocha = {
          rosewater = "f5e0dc"; #f5e0dc
          flamingo = "f2cdcd"; #f2cdcd
          pink = "f5c2e7"; #f5c2e7
          mauve = "cba6f7"; #cba6f7
          red = "f38ba8"; #f38ba8
          maroon = "eba0ac"; #eba0ac
          peach = "fab387"; #fab387
          yellow = "f9e2af"; #f9e2af
          green = "a6e3a1"; #a6e3a1
          teal = "94e2d5"; #94e2d5
          sky = "89dceb"; #89dceb
          sapphire = "74c7ec"; #74c7ec
          blue = "89b4fa"; #89b4fa
          lavender = "b4befe"; #b4befe
          text = "cdd6f4"; #cdd6f4
          subtext1 = "bac2de"; #bac2de
          subtext0 = "a6adc8"; #a6adc8
          overlay2 = "9399b2"; #9399b2
          overlay1 = "7f849c"; #7f849c
          overlay0 = "6c7086"; #6c7086
          surface2 = "585b70"; #585b70
          surface1 = "45475a"; #45475a
          surface0 = "313244"; #313244
          base = "1e1e2e"; #1e1e2e
          mantle = "181825"; #181825
          crust = "11111b"; #11111b
        };
        macchiato = {
          rosewater = "f5e0dc"; #f5e0dc
          flamingo = "f2cdcd"; #f2cdcd
          pink = "f5c2e7"; #f5c2e7
          mauve = "cba6f7"; #cba6f7
          red = "f38ba8"; #f38ba8
          maroon = "eba0ac"; #eba0ac
          peach = "fab387"; #fab387
          yellow = "f9e2af"; #f9e2af
          green = "a6e3a1"; #a6e3a1
          teal = "94e2d5"; #94e2d5
          sky = "89dceb"; #89dceb
          sapphire = "74c7ec"; #74c7ec
          blue = "89b4fa"; #89b4fa
          lavender = "b4befe"; #b4befe
          text = "cdd6f4"; #cdd6f4
          subtext1 = "bac2de"; #bac2de
          subtext0 = "a6adc8"; #a6adc8
          overlay2 = "9399b2"; #9399b2
          overlay1 = "7f849c"; #7f849c
          overlay0 = "6c7086"; #6c7086
          surface2 = "585b70"; #585b70
          surface1 = "45475a"; #45475a
          surface0 = "313244"; #313244
          base = "1e1e2e"; #1e1e2e
          mantle = "181825"; #181825
          crust = "11111b"; #11111b
        };
        frappe = {
          rosewater = "f2d5cf"; #f2d5cf
          flamingo = "eebebe"; #eebebe
          pink = "f4b8e4"; #f4b8e4
          mauve = "ca9ee6"; #ca9ee6
          red = "e78284"; #e78284
          maroon = "ea999c"; #ea999c
          peach = "ef9f76"; #ef9f76
          yellow = "e5c890"; #e5c890
          green = "a6d189"; #a6d189
          teal = "81c8be"; #81c8be
          sky = "99d1db"; #99d1db
          sapphire = "85c1dc"; #85c1dc
          blue = "8caaee"; #8caaee
          lavender = "babbf1"; #babbf1
          text = "c6d0f5"; #c6d0f5
          subtext1 = "b5bfe2"; #b5bfe2
          subtext0 = "a5adce"; #a5adce
          overlay2 = "949cbb"; #949cbb
          overlay1 = "838ba7"; #838ba7
          overlay0 = "737994"; #737994
          surface2 = "626880"; #626880
          surface1 = "51576d"; #51576d
          surface0 = "414559"; #414559
          base = "303446"; #303446
          mantle = "292c3c"; #292c3c
          crust = "232634"; #232634
        };
        latte = {
          rosewater = "dc8a78"; #dc8a78
          flamingo = "dd7878"; #dd7878
          pink = "ea76cb"; #ea76cb
          mauve = "8839ef"; #8839ef
          red = "d20f39"; #d20f39
          maroon = "e64553"; #e64553
          peach = "fe640b"; #fe640b
          yellow = "df8e1d"; #df8e1d
          green = "40a02b"; #40a02b
          teal = "179299"; #179299
          sky = "04a5e5"; #04a5e5
          sapphire = "209fb5"; #209fb5
          blue = "1e66f5"; #1e66f5
          lavender = "7287fd"; #7287fd
          text = "4c4f69"; #4c4f69
          subtext1 = "5c5f77"; #5c5f77
          subtext0 = "6c6f85"; #6c6f85
          overlay2 = "7c7f93"; #7c7f93
          overlay1 = "8c8fa1"; #8c8fa1
          overlay0 = "9ca0b0"; #9ca0b0
          surface2 = "acb0be"; #acb0be
          surface1 = "bcc0cc"; #bcc0cc
          surface0 = "ccd0da"; #ccd0da
          base = "eff1f5"; #eff1f5
          mantle = "e6e9ef"; #e6e9ef
          crust = "dce0e8"; #dce0e8
        };
      };
      cognates = value: {
        borderActive1 = variants.${value}.mauve;
        borderActive2 = variants.${value}.rosewater;
        borderInactive1 = variants.${value}.lavender;
        borderInactive2 = variants.${value}.overlay0;
        text = variants.${value}.text;
        textField = variants.${value}.surface0;
        bg = variants.${value}.base;
        darkBg = variants.${value}.blue;
        failure = variants.${value}.red;
        warning = variants.${value}.yellow;
        blue = variants.${value}.blue;
        red = variants.${value}.red;
        purple = variants.${value}.mauve;
        pink = variants.${value}.pink;
        yellow = variants.${value}.yellow;
        green = variants.${value}.green;
      };
    };
    dracula = rec {
      variants = {
        standard = {
          background = "282a36"; #282a36
          currentLine = "44475a"; #44475a
          foreground = "f8f8f2"; #f8f8f2
          comment = "6272a4"; #6272a4
          cyan = "8be9fd"; #8be9fd
          green = "50fa7b"; #50fa7b
          orange = "ffb86c"; #ffb86c
          pink = "ff79c6"; #ff79c6
          purple = "bd93f9"; #bd93f9
          red = "ff5555"; #ff5555
          yellow = "f1fa8c"; #f1fa8c
        };
        alucard = {
          background = "f8f8f2"; #f8f8f2
          currentLine = "e2e4e5"; #e2e4e5
          foreground = "282a36"; #282a36
          comment = "6272a4"; #6272a4
          cyan = "8be9fd"; #8be9fd
          green = "50fa7b"; #50fa7b
          orange = "ffb86c"; #ffb86c
          pink = "ff79c6"; #ff79c6
          purple = "bd93f9"; #bd93f9
          red = "ff5555"; #ff5555
          yellow = "f1fa8c"; #f1fa8c
        };
      };
      cognates = value: {
        borderActive1 = variants.${value}.green;
        borderActive2 = variants.${value}.cyan;
        borderInactive1 = variants.${value}.comment;
        borderInactive2 = variants.${value}.currentLine;
        text = variants.${value}.foreground;
        textField = variants.${value}.currentLine;
        bg = variants.${value}.background;
        darkBg = variants.${value}.purple;
        failure = variants.${value}.red;
        warning = variants.${value}.yellow;
        blue = variants.${value}.cyan;
        red = variants.${value}.red;
        purple = variants.${value}.purple;
        pink = variants.${value}.pink;
        yellow = variants.${value}.yellow;
        green = variants.${value}.green;
      };
    };
  };
  colorSchemeEnums = lib.attrNames colorSchemes;
  defaultScheme = lib.elemAt colorSchemeEnums 0;
  defaultVariant = lib.elemAt (lib.attrNames colorSchemes.${defaultScheme}.variants) 0;
  colorSchemeSubmodule = with lib;
    types.submodule {
      options = {
        name = mkOption {
          type = types.enum colorSchemeEnums;
          default = defaultScheme;
        };
        variant = mkOption {
          type = types.str;
          default = defaultVariant;
        };
        props = mkOption {
          type = types.attrs;
          default = colorSchemes.${defaultScheme}.variants.${defaultVariant};
        };
        cognates = mkOption {
          type = types.attrs;
          default = colorSchemes.${defaultScheme}.cognates defaultVariant;
        };
        all = mkOption {
          type = types.attrs;
          default = {};
        };
      };
    };
in {
  options.hm.theme = with lib; {
    colorScheme = mkOption {
      type = colorSchemeSubmodule;
    };
  };

  config = {
    hm.theme.colorScheme.props = let
      variantEnums = lib.attrNames colorSchemes.${cfg.name}.variants;
    in
      assert lib.assertOneOf "variant" cfg.variant variantEnums; colorSchemes.${cfg.name}.variants.${cfg.variant};

    hm.theme.colorScheme.cognates = colorSchemes.${cfg.name}.cognates cfg.variant;
    hm.theme.colorScheme.all = (lib.mkIf config.hm.hotload.enable) colorSchemes;
  };
}
