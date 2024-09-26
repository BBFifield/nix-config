{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.theme;

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
  options.hm.theme = {
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
  };
}
