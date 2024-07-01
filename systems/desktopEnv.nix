{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.desktopEnv;
in
{
  options.desktopEnv = {
    enable = mkOption {
      type = types.enum [ "plasma" "gnome" null ];
      default = null;
      example = "plasma";
      description = mdDoc "Choose the preferred desktop environment";
    };
  };

  config =  mkMerge [
	(mkIf (cfg.enable == "plasma") {
	  services.xserver.enable = true;

	  # Enable the KDE Plasma 6 Desktop Environment.
	  services.displayManager.sddm = {
	    enable = true;
	    wayland.enable = true;
	    wayland.compositor = "kwin";
	  };
	  services.desktopManager.plasma6.enable = true;

	  environment.systemPackages = with pkgs.kdePackages; [
	    sddm-kcm
	    partitionmanager
	    kpmcore
	    kde-cli-tools
	    kdbusaddons
		isoimagewriter
      ];
    })

    (mkIf (cfg.enable == "gnome") {
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

      programs.dconf.profiles.gdm.databases =
      [{
		settings = {
  	      "org/gnome/desktop/interface" = {
		    scaling-factor = lib.gvariant.mkUint32 2;
		  };
  	    };
  	  }];
    })
  ];

}
