{ config, pkgs, ... }:

{
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";

  home.packages = with pkgs; [

  ];

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
