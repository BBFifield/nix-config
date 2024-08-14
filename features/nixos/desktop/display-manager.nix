# Credit goes to github:Cu3P042 for the code snippet which changes the users' avatar in sddm.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  options.desktop = {
    displayManager = mkOption {
      type = types.enum ["sddm" "gdm" "greetd" null];
      default = null;
      example = "sddm";
      description = mdDoc "Choose the preferred display-manager.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.displayManager == "gdm") {
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      programs.dconf.profiles.gdm.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              scaling-factor = lib.gvariant.mkUint32 2;
            };
          };
        }
      ];
    })

    (mkIf (cfg.displayManager == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        package = lib.mkForce pkgs.kdePackages.sddm;
        wayland.enable = true;
        settings = {
          Theme = {
            CursorSize = 56; #Doubled the size for hidpi display
            CursorTheme = "BreezeX-Dark";

            FacesDir = "/var/lib/AccountsService/icons";
          };
          General = {
            GreeterEnvironment = "QT_FONT_DPI=192";# QT_SCREEN_SCALE_FACTORS=2"; 
          };
        };
      };
    })

    (mkIf (cfg.displayManager == "greetd") {
      services.greetd = {
        enable = true;
      };
    })
  ];
}
