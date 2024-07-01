{ pkgs, lib, ... }:

{
  # Enable the Gnome desktop environment
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    settings = {

    };
  };

  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.dconf-editor
    dconf2nix
  ];

  programs.dconf.profiles.gdm.databases = [{
  	  settings = {
  	    "org/gnome/desktop/interface" = {
				scaling-factor = lib.gvariant.mkUint32 2;
			};
  	  };
  	}];

}
