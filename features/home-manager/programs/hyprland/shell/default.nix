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

  switch_conf = pkgs.writeShellScript "switch_conf" ''
    #!/usr/bin/env bash
    directory=${config.home.homeDirectory}/.config/hypr
    current_colorscheme="$1"
    switch_config() {
      rm "$directory/hyprland_colors.conf"
      cp -rf "$directory/hyprland_colorschemes/$1" "$directory/hyprland_colors.conf"
    }

    if [ "$(ls -1 "$directory/hyprland_colorschemes" | wc -l)" -le 1 ]; then
      exit 1
    else
      next_colorscheme=$(ls -1 "$directory/hyprland_colorschemes" | sed -n "/$current_colorscheme/{n;p}")
      if [[ -z "$next_colorscheme" ]]; then
        next_colorscheme=$(ls -1 "$directory/hyprland_colorschemes" | sed -n '1p')
      fi
    fi
    switch_config "$next_colorscheme"
    hyprctl reload
  '';

  settings = theme: cognates: let
    inherit cognates;
    activeBorder1 = cognates.borderActive1;
    activeBorder2 = cognates.borderActive2;
    inactiveBorder1 = cognates.borderInactive1;
    inactiveBorder2 = cognates.borderInactive2;
  in {
    exec-once =
      [
        "wpaperd -d"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ]
      ++ (lib.optionals (config.hm.gBar.enable) ["gBar bar 0"]);

    env = [
      "CURRENT_COLORSCHEME,hyprland_${theme}.conf"
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
      ''SUPER, T, exec, ${switch_conf} hyprland_${theme}.conf''
      "SUPER, R, exec, walker"
      "SUPER, N, exec, wpaperctl next"
      "SUPER, P, exec, hyprpicker --autocopy"
      "SUPER CTRL, H, exec, hyprshade toggle blue-light-filter"
      "SUPER, S, exec, grim -g \"$(slurp -o -r -c '##${activeBorder1}ff')\" -t ppm - | satty --filename -"
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

          result = lib.listToAttrs (builtins.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = attrset.${theme}.cognates variant;
            }) (getVariantNames theme))
          themeNames);

          createFile = name: value: {
            xdg.configFile."hypr/hyprland_colorschemes/hyprland_${name}.conf".text = lib.hm.generators.toHyprconf {
              attrs = settings name value;
              inherit (config.wayland.windowManager.hyprland) importantPrefixes;
            };
          };

          files = mkMerge [
            (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: createFile name value) result)))
            {
              xdg.configFile."hypr/hyprland_colors.conf".text = let
                name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
                cognates = config.hm.theme.colorscheme.cognates;
              in
                lib.hm.generators.toHyprconf {
                  attrs = settings name cognates;
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
              hm.ironbar.enable = true;

              home.packages = with pkgs; [
                hyprpicker
                clipse #TUI clipboard manager
                hyprshade #Screenshader utility
                slurp #For screen recording and screenshotting
                grim #Screenshotter
              ];
            }
            (lib.mkIf (cfg.hotload.enable)
              {
                wayland.windowManager.hyprland.extraConfig = ''
                  source = ${config.home.homeDirectory}/.config/hypr/hyprland_colors.conf
                '';
              })
            (lib.mkIf (cfg.hotload.enable) files)
            {
              wayland.windowManager.hyprland = (lib.mkIf (!cfg.hotload.enable)) {
                settings = let
                  name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
                  cognates = config.hm.theme.colorscheme.cognates;
                in
                  settings name cognates;
              };
            }
          ]
      ))
    ]
  );
}
