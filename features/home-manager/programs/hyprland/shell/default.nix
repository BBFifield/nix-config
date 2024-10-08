{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.hm.hyprland.enable (
    mkMerge [
      (mkIf (config.hm.hyprland.shell == "hyprpanel") {
        home = {
          packages = with pkgs; [
            hyprpanel
          ];
        };

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "${pkgs.hyprpanel}/bin/hyprpanel"
            ];
          };
        };
      })
      (mkIf (config.hm.hyprland.shell == "asztal") {
        home = {
          packages = with pkgs; [
            asztal
          ];
        };

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "asztal -b hypr"
            ];

            bind = let
              e = "exec, asztal -b hypr";
            in [
              "CTRL SHIFT, R,  ${e} quit; asztal -b hypr"
              "SUPER, R,       ${e} -t launcher"
              "SUPER, Tab,     ${e} -t overview"
              ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
              ",XF86Launch4,   ${e} -r 'recorder.start()'"
              ",Print,         ${e} -r 'recorder.screenshot()'"
              "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
            ];
          };
        };
      })
      (mkIf (config.hm.hyprland.shell == "vanilla") {
        #hm.gBar.enable = true;
        hm.wpaperd.enable = true;
        hm.hyprland.hyprlock.enable = true;
        hm.walker.enable = true;
        hm.satty.enable = true;
        hm.ironbar.enable = true;

        home.packages = with pkgs; [
          hyprpicker
          clipse #TUI clipboard manager
          hyprshade #Screenshader utility
          slurp #For screenrecording and screenshotting
          grim #Screenshotter
        ];

        wayland.windowManager.hyprland = {
          settings = let
            cfg = config.hm.theme.colorScheme.props;
            activeBorder1 = cfg.borderActive1;
            activeBorder2 = cfg.borderActive2;
            inactiveBorder1 = cfg.borderInactive1;
            inactiveBorder2 = cfg.borderInactive2;
          in {
            exec-once = mkMerge [
              [
                "wpaperd -d"
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              ]
              (mkIf (config.hm.gBar.enable == true) ["gBar bar 0"])
            ];

            general = {
              "col.active_border" = "rgba(${activeBorder1}ff) rgba(${activeBorder2}ff) 45deg";
              "col.inactive_border" = "rgba(${inactiveBorder1}cc) rgba(${inactiveBorder2}cc) 45deg";
            };

            group = {
              "col.border_active" = "rgba(${activeBorder1}ff) rgba(${activeBorder2}ff) 45deg";
              "col.border_inactive" = "rgba(${inactiveBorder1}cc) rgba(${inactiveBorder2}cc) 45deg";
              "col.border_locked_active" = "rgba(${activeBorder1}ff) rgba(${activeBorder2}ff) 45deg";
              "col.border_locked_inactive" = "rgba(${inactiveBorder1}cc) rgba(${inactiveBorder2}cc) 45deg";
            };

            bind = [
              "SUPER, R, exec, walker"
              "SUPER, N, exec, wpaperctl next"
              "SUPER, P, exec, hyprpicker --autocopy"
              "SUPER CTRL, H, exec, hyprshade toggle blue-light-filter"
              ''SUPER, S, exec, grim -g "$(slurp -o -r -c '##${activeBorder1}ff')" -t ppm - | satty --filename -''
            ];
          };
          #For catppuccin style variables for other hypr apps
          /*
            extraConfig = mkMerge [
            (mkIf (config.hm.theme.colorScheme == "catppuccin")
              ''
                ${builtins.readFile ../mocha.conf}
              '')
          ];
          */
        };
      })
    ]
  );
}
