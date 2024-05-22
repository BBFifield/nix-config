{ pkgs, lib, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  #defaultPkgs = with pkgs; [
   # nur.repos.slaier.wavefox
  #];
in
{

  programs.home-manager.enable = true;

  imports = lib.concatMap import [
    ./programs
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";

    #packages = defaultPkgs;

  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
