{ pkgs, config, lib, desktopEnv, ... }:

{

  plasma6 = [
    (import ./browsers/firefox {inherit pkgs lib desktopEnv; })
    ./konsole
    ./plasma
    ./klassy
  ];

  gnome = [
    ./browsers/firefox
    ./dconf
  ];

}
