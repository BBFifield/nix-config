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
        hm.gBar.enable = true;
        hm.wpaperd.enable = true;
        hm.hyprland.hyprlock.enable = true;
        hm.walker.enable = true;

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "gBar bar 0"
              "wpaperd -d"
            ];

            general = {
              "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            };

            group = {
              "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            };

            bind = [
              "SUPER, R, exec, walker"
              "SUPER, N, exec, wpaperctl next"
            ];
          };
          extraConfig = ''
            ${builtins.readFile ../mocha.conf}
          '';
        };
      })
    ]
  );
}
