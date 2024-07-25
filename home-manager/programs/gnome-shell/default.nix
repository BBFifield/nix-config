{...}: {
  home.packages = with pkgs;
    [
      adw-gtk3
      gnome-builder
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
      tela-icon-theme
      orchis-theme
    ]
    ++ (icons.breezeXcursor); #For the cursor
}
