# dataFile attribute corresponds to $XDG_DATA_HOME which when null, is equal to /home/<username>/.local/share
{
  config,
  lib,
  ...
}: {
  options.hm.konsole = {
    enable = lib.mkEnableOption "Enable konsole configuration";
  };

  config = lib.mkIf config.hm.konsole.enable {
    programs.konsole = {
      enable = true;
      profiles = {
        "Default" = {
          colorScheme = "Breeze";
        };
      };
      defaultProfile = "Default";
      extraConfig = {
        TabBar.CloseTabOnMiddleMouseButton = true;
      };
      customColorSchemes = {BreezeBlur = ./BreezeBlur.colorscheme;};
    };

    /*
      programs.plasma.dataFile."konsole/Breeze.colorscheme".General = {
      Blur = {
        value = true;
      };
      Opacity = {
        value = 0.7;
      };
    };
    */
  };
}
