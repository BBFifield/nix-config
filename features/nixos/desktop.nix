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
      description = mdDoc "Choose the preferred desktop environment";
    };
  };

  config =
    {services.xserver.enable = true;}
    // (mkIf (cfg.enable) (
      mkMerge [
        (mkIf (cfg.session == "plasma") {
          # Enable the KDE Plasma 6 Desktop Environment.
          services.desktopManager.plasma6.enable = true;

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
          # Enable the Gnome desktop environment
          services.xserver.desktopManager.gnome.enable = true;
          services.xserver.displayManager.gdm = {
            enable = true;
            wayland = true;
          };

          environment.systemPackages = with pkgs; [
            gnome-tweaks
            dconf-editor
            dconf2nix
          ];

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

        (mkIf (cfg.session == "hyprland") {
          # Enable the hyprland desktop environment
          programs.hyprland.enable = true;

          services.gvfs.enable = true; # Need this to see trash folder
          security.pam.services.hyprlock = {}; # Need this for hyprlock to work

          environment.systemPackages = with pkgs; [
            bun
            gnome-tweaks
            kdePackages.qtwayland #QT apps will not open under wayland mode otherwise
            kdePackages.qt6ct
            icons.breezeXcursor # custom # Needs to be installed system-wide to be accessible to sddm
          ];
        })
      ]
    ));
}
