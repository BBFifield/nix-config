{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktopEnv;
in {
  options.desktopEnv = {
    enable = mkEnableOption "Enable a desktop environment";

    choice = mkOption {
      type = types.enum ["plasma" "gnome" "hyprland" null];
      default = null;
      example = "plasma";
      description = mdDoc "Choose the preferred desktop environment";
    };
  };

  config = (mkIf (cfg.enable) (
    mkMerge [
      (mkIf (cfg.choice == "plasma") {
        services.xserver.enable = true;

        # Enable the KDE Plasma 6 Desktop Environment.
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          wayland.compositor = "kwin";
          theme = "breeze";
          settings = {
            Theme = {
              CursorSize = 28;
              CursorTheme = "BreezeX-Dark";
            };
          };
        };
        services.desktopManager.plasma6.enable = true;

        environment.systemPackages = with pkgs.kdePackages; [
          sddm-kcm
          partitionmanager
          kpmcore
          kde-cli-tools
          kdbusaddons
          isoimagewriter
        ]
        ++ (with (callPackage ../pkgs/icons {}); [breezeXcursor]); # Needs to be installed system-wide so sddm has access to it
      })

      (mkIf (cfg.choice == "gnome") {
        # Enable the Gnome desktop environment
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.displayManager.gdm = {
          enable = true;
          wayland = true;
        };

        services.xserver.enable = true;

        environment.systemPackages = with pkgs; [
          gnome-tweaks
          dconf-editor
          dconf2nix
        ];

        programs.dconf.profiles.gdm.databases = [
          { settings = {
              "org/gnome/desktop/interface" = {
                scaling-factor = lib.gvariant.mkUint32 2;
              };
            };
          }
        ];
      })

      (mkIf (cfg.choice == "hyprland") {
        # Enable the hyprland desktop environment
        programs.hyprland.enable = true;
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          wayland.compositor = "weston";
          theme = "Elegant";
          settings = {
            Theme = {
              CursorSize = 28;
              CursorTheme = "BreezeX-Dark";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          gnome-tweaks
          dconf-editor
          dconf2nix
          elegant-sddm
        ]
        ++ (with (callPackage ../pkgs/icons {}); [breezeXcursor]);
      })
    ]
  ));
}

