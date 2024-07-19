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

    session = mkOption {
      type = types.enum ["plasma" "gnome" "hyprland" null];
      default = null;
      example = "plasma";
      description = mdDoc "Choose the preferred desktop environment";
    };
  };

  config = (mkIf (cfg.enable) (
    mkMerge [
      (mkIf (cfg.session == "plasma") {
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

      (mkIf (cfg.session == "gnome") {
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

      (mkIf (cfg.session == "hyprland") {
        # Enable the hyprland desktop environment
        programs.hyprland.enable = true;
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          wayland.compositor = "weston";
          theme = "chili";
          settings = {
            General = {
              GreeterEnvironment="QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
            };
            Theme = {
              CursorSize = 28;
              CursorTheme = "BreezeX-Dark";
            };
          };
        };
        
        services.gvfs.enable = true; # Need this to see trash folder
        security.pam.services.hyprlock = {};

        environment.systemPackages = with pkgs; [
          bun
          gnome-tweaks
          sddm-chili-theme
          kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
          kdePackages.qt6ct
        ]
        ++ (with (callPackage ../pkgs/icons {}); [breezeXcursor]); # Needs to be installed system-wide to be accessible to sddm
      })
    ]
  ));
}

