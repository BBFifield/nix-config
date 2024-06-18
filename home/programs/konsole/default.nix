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


}
