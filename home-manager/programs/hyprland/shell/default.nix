{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.hm.hyprland.enable (
    mkMerge [
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

            decoration = {
              drop_shadow = "yes";
              shadow_range = 8;
              shadow_render_power = 2;
              "col.shadow" = "rgba(00000044)";

              # Change transparency of focused and unfocused windows
              active_opacity = 0.95;
              inactive_opacity = 0.9;

              dim_inactive = false;

              blur = {
                enabled = true;
                size = 8;
                passes = 3;
                new_optimizations = "on";
                noise = 0.01;
                contrast = 0.9;
                brightness = 0.8;
                popups = true;
              };
            };
          };
        };
      })
      (mkIf (config.hm.hyprland.shell == "vanilla") {
        hm.gBar.enable = true;
        hm.wpaperd.enable = true;
        hm.hyprland.hyprlock.enable = true;

        home.packages = with pkgs; [ walker ];

        wayland.windowManager.hyprland = {
          settings = {
            exec-once = [
              "gBar bar 0"
              "wpaperd"
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
            ];
          };
        };
      })
    ]
  );
}
