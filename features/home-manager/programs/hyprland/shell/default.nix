{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland.shell;
  shellSubmodule = lib.types.submodule {
    options = {
      name = mkOption {
        type = with types; nullOr (enum ["vanilla" "asztal" "hyprpanel"]);
        default = null;
        description = "Choose a customized shell.";
      };
      hotload = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).hotload;
      };
      baseConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };

  settings = {
    source =
      [
        "${config.home.homeDirectory}/.config/hypr/hyprland_colorscheme.conf"
      ]
      ++ (lib.optionals (config.hm.hyprland.shell.hotload.enable) ["${config.home.homeDirectory}/.config/hypr/colorscheme_settings.conf"]);

    exec-once =
      [
        "wpaperd -d"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ]
      ++ (lib.optionals (config.hm.gBar.enable) ["gBar bar 0"]);

    general = {
      "col.active_border" = "0xff$activeBorder1 0xff$activeBorder2 45deg";
      "col.inactive_border" = "0xcc$inactiveBorder1 0xcc$inactiveBorder2 45deg";
    };

    group = {
      "col.border_active" = "0xff$activeBorder1 0xff$activeBorder2 45deg";
      "col.border_inactive" = "0xcc$inactiveBorder1 0xcc$inactiveBorder2 45deg";
      "col.border_locked_active" = "0xff$activeBorder 0xff$activeBorder2 45deg";
      "col.border_locked_inactive" = "0xcc$inactiveBorder1 0xcc$inactiveBorder2 45deg";
    };

    bind = [
      "SUPER, R, exec, walker"
      "SUPER, N, exec, wpaperctl next"
      "SUPER, P, exec, hyprpicker --autocopy"
      "SUPER CTRL, H, exec, hyprshade toggle blue-light-filter"
      "SUPER, S, exec, grim -g \"$(slurp -o -r -c '##$activeBorder1ff')\" -t ppm - | satty --filename -"
    ];
  };

  colorschemeSettings = theme: {
    bind = ''SUPER, T, exec, switch-colorscheme ${theme}'';
    env = [
      "CURRENT_COLORSCHEME,${theme}.conf"
    ];
  };
in {
  options.hm.hyprland = {
    shell = mkOption {
      type = shellSubmodule;
      description = "Choose a customized shell.";
    };
  };

  config = mkIf config.hm.hyprland.enable (
    mkMerge [
      (mkIf (config.hm.hyprland.shell.name == "hyprpanel") {
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
      (mkIf (config.hm.hyprland.shell.name == "asztal") {
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
      (mkIf (cfg.name == "vanilla") (
        let
          attrset = import ../../../themes/colorschemeInfo.nix;
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          mkColorPrefix = name: value: {
            name = "\$${name}";
            value = "${value}";
          };

          unpacked = lib.listToAttrs (lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = attrset.${theme}.cognates variant;
            }) (getVariantNames theme))
          themeNames);

          unpacked2 = lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = let
                cognates = attrset.${theme}.cognates variant;
              in
                lib.map (cognateName: mkColorPrefix cognateName cognates.${cognateName}) (lib.attrNames cognates);
            }) (getVariantNames theme))
          themeNames;

          mkColorFile = name: value: {
            xdg.configFile."hypr/hyprland_colorschemes/${name}.conf".text = lib.hm.generators.toHyprconf {
              attrs = value;
            };
          };

          mkSettingsFile = name: value: {
            xdg.configFile."hypr/colorscheme_settings/${name}.conf".text = lib.hm.generators.toHyprconf {
              attrs = colorschemeSettings name;
              # inherit (config.wayland.windowManager.hyprland) importantPrefixes;
            };
          };

          colorFiles = mkMerge [
            (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name (lib.listToAttrs value)) (lib.listToAttrs unpacked2))))
          ];

          settingsFiles = mkMerge [
            (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: mkSettingsFile name value) unpacked)))
            {
              xdg.configFile."hypr/colorscheme_settings.conf".text = let
                name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
              in
                lib.hm.generators.toHyprconf {
                  attrs = colorschemeSettings name;
                  inherit (config.wayland.windowManager.hyprland) importantPrefixes;
                };
            }
          ];
        in
          mkMerge [
            {
              hm.wpaperd.enable = true;
              hm.hyprland.hyprlock.enable = true;
              hm.walker.enable = true;
              hm.satty.enable = true;
              hm.ironbar = {
                enable = true;
                hotload.enable = true;
              };
              home.packages = with pkgs; [
                hyprpicker
                clipse #TUI clipboard manager
                hyprshade #Screenshader utility
                slurp #For selecting region of the screen
                grim #Screenshotter
              ];

              wayland.windowManager.hyprland = {
                inherit settings;
              };

              xdg.configFile."hypr/hyprland_colorscheme.conf".text = let
                name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
              in
                lib.hm.generators.toHyprconf {
                  attrs = lib.listToAttrs ((lib.head (lib.filter (theme: name == theme.name) unpacked2)).value);
                };
            }
            (lib.mkIf (cfg.hotload.enable) (mkMerge [
              {
                hm.hotload.scriptParts = {
                  "2" = ''
                    rm "$directory/hypr/colorscheme_settings.conf" "$directory/hypr/hyprland_colorscheme.conf"
                    cp -rf "$directory/hypr/hyprland_colorschemes/$1.conf" "$directory/hypr/hyprland_colorscheme.conf"
                    cp -rf "$directory/hypr/colorscheme_settings/$1.conf" "$directory/hypr/colorscheme_settings.conf"
                  '';
                  "5" = ''
                    hyprctl reload
                  '';
                };
              }
              colorFiles
              settingsFiles
            ]))
          ]
      ))
    ]
  );
}
