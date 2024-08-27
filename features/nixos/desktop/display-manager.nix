# Credit goes to github:Cu3P042 for the code snippet which changes the users' avatar in sddm.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;
in {
  options.nixos.desktop = {
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
              (mkIf (cfg.hidpi.enable) {
                scaling-factor = lib.gvariant.mkUint32 2;
              })
              (mkIf (!cfg.hidpi.enable) {
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
            Theme.CursorSize = 48; #BreezeX has problems with using 56px for some reason
            General.GreeterEnvironment = "QT_SCALE_FACTOR=2";
          })
          (mkIf (!cfg.hidpi.enable) {
            Theme.CursorSize = 24;
            General.GreeterEnvironment = "QT_SCALE_FACTOR=1";
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
