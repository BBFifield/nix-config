# Credit goes to github:Cu3P042 for the code snippet which changes the users' avatar in sddm.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
in
{
  config =
    mkMerge [
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



      (mkIf (cfg.displayManager == "sddm"){
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          settings = {
            Theme = {
              CursorSize = 28;
              CursorTheme = "BreezeX-Dark";

              FacesDir = "/var/lib/AccountsService/icons";
            };
          };
        };
      })
      (mkIf (cfg.session == "plasma") {
        environment.systemPackages = with pkgs.kdePackages; [sddm-kcm];
        services.displayManager.sddm = {
          wayland.compositor = "kwin";
          theme = "breeze";
        };
      })
      (mkIf (cfg.session == "hyprland" && cfg.displayManager == "sddm") {
        environment.systemPackages = with pkgs; [sddm-chili-theme];
        services.displayManager.sddm = {
          wayland.compositor = "weston";
          theme = "chili";
          settings = {
            General = {
              GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
            };
          };
        };
      })


      
      (mkIf (cfg.session == "hyprland" && cfg.displayManager == "greetd") { 
        services.greetd = {
          enable = true;
          settings.default_session.command = pkgs.writeShellScript "greeter" ''
            export WLR_NO_HARDWARE_CURSORS=1
            export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
            export XCURSOR_THEME=BreezeX-Dark
            export XCURSOR_SIZE=28
            ${pkgs.asztal}/bin/greeter
          '';
        };

        systemd.tmpfiles.rules = [
          "d '/var/cache/greeter' - greeter greeter - -"
        ];

        system.activationScripts.wallpaper = let
          wp = pkgs.writeShellScript "wp" ''
            CACHE="/var/cache/greeter"
            OPTS="$CACHE/options.json"
            HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"

            mkdir -p "$CACHE"
            chown greeter:greeter $CACHE

            if [[ -f "$HOME/.cache/ags/options.json" ]]; then
              cp $HOME/.cache/ags/options.json $OPTS
              chown greeter:greeter $OPTS
            fi

            if [[ -f "$HOME/.config/background" ]]; then
              cp "$HOME/.config/background" $CACHE/background
              chown greeter:greeter "$CACHE/background"
            fi
          '';
        in
          builtins.readFile wp;
      })
    ];
}