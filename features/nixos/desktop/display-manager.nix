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

    hidpi = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable hidpi display resolution.";
        };
      };
      default = {};
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
            "org/gnome/desktop/interface" = mkMerge [
              (optionalAttrs (cfg.displayManager.hidpi.enable) {
                scaling-factor = lib.gvariant.mkUint32 2;
              })
              (optionalAttrs (!cfg.displayManager.hidpi.enable) {
                scaling-factor = lib.gvariant.mkUint32 1;
              })
            ];
          };
        }
      ];
    })

    (mkIf (cfg.displayManager == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        package = lib.mkForce pkgs.kdePackages.sddm;
        wayland.enable = true;
        settings = mkMerge [
          {
            Theme = {
              CursorTheme = "BreezeX-Dark";
              FacesDir = "/var/lib/AccountsService/icons";
            };
          }
          (mkIf (cfg.hidpi.enable) {
            Theme.CursorSize = 56;
            General.GreeterEnvironment = "QT_FONT_DPI=192";
          })
          (mkIf (!cfg.hidpi.enable) {
            Theme.CursorSize = 28;
            General.GreeterEnvironment = "QT_FONT_DPI=96";
          })
        ];
      };
    })

    (mkIf (cfg.displayManager == "greetd") {
      services.greetd = {
        enable = true;
      };
    })
  ];
}
