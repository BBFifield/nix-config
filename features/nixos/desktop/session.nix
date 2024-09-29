{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nixos.desktop;

  plasmaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable the plasma desktop environment.";
    };
  };
  gnomeSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable the gnome desktop environment.";
    };
  };
  hyprlandSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Enable Hyprland Window Manager.";
      shell = mkOption {
        type = types.enum ["asztal" "vanilla" "hyprpanel"];
        default = "vanilla";
        description = "Choose your preferred Hyprland shell";
        example = "asztal";
      };
    };
  };
in {
  options.nixos.desktop = {
    plasma = mkOption {
      type = plasmaSubmodule;
      default = {
        enable = false;
      };
    };
    gnome = mkOption {
      type = gnomeSubmodule;
      default = {
        enable = false;
      };
    };
    hyprland = mkOption {
      type = hyprlandSubmodule;
      default = {
        enable = false;
        shell = "vanilla";
      };
    };
  };

  config =
    {services.xserver.enable = true;}
    // mkMerge [
      (mkIf (cfg.plasma.enable) {
        # Enable the KDE Plasma 6 Desktop Environment.
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

      (mkIf (cfg.gnome.enable) {
        # Enable the Gnome desktop environment
        services.xserver.desktopManager.gnome.enable = true;

        environment.systemPackages = with pkgs; [
          gnome-tweaks
          dconf-editor
          dconf2nix
        ];
      })

      (mkIf (cfg.hyprland.enable) (
        mkMerge [
          {
            # Enable the hyprland "desktop environment"
            programs.hyprland.enable = true;
            environment.systemPackages = with pkgs; [
              bun
              gnome-tweaks
              kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
              kdePackages.qt6ct
              morewaita-icon-theme
              adwaita-icon-theme
              qogir-icon-theme
              gnome-control-center
            ];

            security = {
              polkit.enable = true;
              pam.services.ags = {};
            };

            systemd = {
              user.services.polkit-gnome-authentication-agent-1 = {
                description = "polkit-gnome-authentication-agent-1";
                wantedBy = ["graphical-session.target"];
                wants = ["graphical-session.target"];
                after = ["graphical-session.target"];
                serviceConfig = {
                  Type = "simple";
                  ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                  Restart = "on-failure";
                  RestartSec = 1;
                  TimeoutStopSec = 10;
                };
              };
            };

            services = {
              gvfs.enable = true;
              devmon.enable = true;
              udisks2.enable = true;
              upower.enable = true;
              power-profiles-daemon.enable = true;
              accounts-daemon.enable = true;
              gnome = {
                evolution-data-server.enable = true;
                glib-networking.enable = true;
                gnome-keyring.enable = true;
                gnome-online-accounts.enable = true;
                tracker-miners.enable = true;
                tracker.enable = true;
              };
            };
          }
          # Hyprlock doesn't work without this
          (mkIf (cfg.hyprland.shell == "vanilla") {
            security.pam.services.hyprlock = {};
          })
        ]
      ))
    ];
}
