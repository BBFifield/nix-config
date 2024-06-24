# dataFile attribute corresponds to $XDG_DATA_HOME which when null, is equal to /home/<username>/.local/share

{ ... }:

{
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
  };

  programs.plasma = {
    dataFile = {
      "konsole/Breeze.colorscheme".General = {
        Blur = {
          value =true;
          immutable = true;
        };
        Opacity = {
          value = 0.7;
          immutable = true;
        };
      };
    };
  };
}
