{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = mkEnableOption "Enable a desktop environment";

    session = mkOption {
      type = types.enum ["plasma" "gnome" "hyprland" null];
      default = null;
      example = "plasma";
      description = mdDoc "Choose the preferred desktop environment.";
    };

    displayManager = mkOption {
      type = types.enum ["sddm" "gdm" "greetd" null];
      default = null;
      example = "sddm";
      description = mdDoc "Choose the preferred display-manager.";
    };
  };

  config =
    {services.xserver.enable = true;}
    // (mkIf (cfg.enable) (
      mkMerge [
        (mkIf (cfg.session == "plasma") {
          warnings =
            if !cfg.displayManager == "sddm"
            then [
              ''                You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to
                                    "sddm" when session = "plasma".
              ''
            ]
            else [];

          # Enable the KDE Plasma 6 Desktop Environment.
          services.desktopManager.plasma6.enable = true;
          environment.variables = {
            GDK_SCALE = "2";
          };

          environment.systemPackages = with pkgs.kdePackages;
            [
              partitionmanager
              kpmcore
              kde-cli-tools
              kdbusaddons
              isoimagewriter
            ]
            ++ [pkgs.icons.breezeXcursor]; # custom # Needs to be installed system-wide so sddm has access to it
        })

        (mkIf (cfg.session == "gnome") {
          warnings =
            if !cfg.displayManager == "gdm"
            then [
              ''                You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to
                                    "gdm" when session = "gnome", otherwise problems with the lockscreen may occur.
              ''
            ]
            else [];

          # Enable the Gnome desktop environment
          services.xserver.desktopManager.gnome.enable = true;

          environment.systemPackages = with pkgs; [
            gnome-tweaks
            dconf-editor
            dconf2nix
          ];
        })

        (mkIf (cfg.session == "hyprland") {
          warnings =
            if cfg.displayManager == "gdm"
            then [
              ''                You have set the display-manager to ${cfg.displayManager}. GDM may cause hyprland to crash on first launch.
              ''
            ]
            else [];

          # Enable the hyprland "desktop environment"
          programs.hyprland.enable = true;

          environment.systemPackages = with pkgs; [
            bun
            gnome-tweaks
            kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
            kdePackages.qt6ct
            icons.breezeXcursor # custom # Needs to be installed system-wide to be accessible to sddm
            morewaita-icon-theme
            adwaita-icon-theme
            qogir-icon-theme
            gnome.gnome-control-center
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
        })
      ]
    ));
}
