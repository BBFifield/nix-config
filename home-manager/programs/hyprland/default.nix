{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  yt = pkgs.writeShellScript "yt" ''
    notify-send "Opening video" "$(wl-paste)"
    mpv "$(wl-paste)"
  '';

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";

  theme = {
    package = pkgs.adw-gtk3;
    name = "adw-gtk3-dark";
  };
  cursorTheme = {
    name = "BreezeX-Dark";
    size = 28;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
  };
  font = {
    name = "Sans";
    size = lib.mkForce 10;
  };
in {
  options.hm.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration via home-manager";
  };

  config = mkIf config.hm.hyprland.enable {
    xdg.desktopEntries = {
      "org.gnome.Settings" = {
        name = "Settings";
        comment = "Gnome Control Center";
        icon = "org.gnome.Settings";
        exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
        categories = ["X-Preferences"];
        terminal = false;
      };
      "org.gnome.Tweaks" = {
        name = "Tweaks";
        comment = "Gnome Tweaks";
        icon = "org.gnome.tweaks";
        exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-tweaks}/bin/gnome-tweaks";
        categories = ["X-Preferences"];
        terminal = false;
      };
    };

    home = {
      packages = with pkgs; [
        #alacritty
        nautilus
        asztal
        morewaita-icon-theme
        adwaita-icon-theme
        qogir-icon-theme
        loupe
        baobab
        gnome-system-monitor
        icons.breezeXcursor
        wl-gammactl
      ];
      sessionVariables = {
        XCURSOR_THEME = cursorTheme.name;
        XCURSOR_SIZE = "${toString cursorTheme.size}";
      };
      pointerCursor = cursorTheme // {gtk.enable = true;};
    };

    gtk = {
      enable = true;
      inherit theme cursorTheme iconTheme font;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
      config = {
        common = {
          default = [
            "gtk"
            "hyprland"
          ];
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      #package = hyprland;
      systemd.enable = true;
      xwayland.enable = true;
      plugins = [
        # inputs.hyprland-hyprspace.packages.${pkgs.system}.default
        # plugins.hyprexpo
        # plugins.hyprbars
        # plugins.borderspp
      ];

      settings = {
        exec-once = [
          "asztal -b hypr"
        ];

        monitor = [
          ",preferred,auto,2"
        ];

        env = [
          "XCURSOR_SIZE,${toString cursorTheme.size}"
          "HYPRCURSOR_SIZE,${toString cursorTheme.size}"
          "HYPRCURSOR_THEME,${cursorTheme.name}"
          "XCURSOR_THEME,${cursorTheme.name}"

          "GDK_BACKEND,wayland,x11,*"
          "GDK_SCALE,2"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt6ct"

          #"QT_PLUGIN_PATH,${pkgs.kdePackages.qtbase}/${pkgs.kdePackages.qtbase.qtPluginPrefix}"
          #"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          layout = "dwindle";
          resize_on_border = true;
        };

        misc = {
          disable_splash_rendering = true;
          force_default_wallpaper = 1;
        };

        input = {
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "yes";
            disable_while_typing = true;
            drag_lock = true;
          };
          sensitivity = 0;
          float_switch_override_focus = 2;
        };

        binds = {
          allow_workspace_cycles = true;
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          # no_gaps_when_only = "yes";
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_use_r = true;
        };

        windowrule = let
          f = regex: "float, ^(${regex})$";
        in [
          (f "org.gnome.Calculator")
          #(f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry.py")
          #(f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "de.haeckerfelix.Fragments")
          (f "com.github.Aylur.ags")
          "workspace 7, title:Spotify"
        ];

        #windowrulev2 = "opacity 0.90 0.85,class:^(Alacritty)$";

        bind = let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          ws = binding "SUPER" "workspace";
          resizeactive = binding "SUPER CTRL" "resizeactive";
          mvactive = binding "SUPER ALT" "moveactive";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          e = "exec, asztal -b hypr";
          arr = [1 2 3 4 5 6 7];
        in
          [
            "CTRL SHIFT, R,  ${e} quit; asztal -b hypr"
            "SUPER, R,       ${e} -t launcher"
            "SUPER, Tab,     ${e} -t overview"
            ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
            ",XF86Launch4,   ${e} -r 'recorder.start()'"
            ",Print,         ${e} -r 'recorder.screenshot()'"
            "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
            "SUPER, Return, exec, xterm" # xterm is a symlink, not actually xterm
            "SUPER, W, exec, firefox"
            "SUPER, E, exec, alacritty"

            # youtube
            ", XF86Launch1,  exec, ${yt}"

            "ALT, Tab, focuscurrentorlast"
            "CTRL ALT, Delete, exit"
            "ALT, Q, killactive"
            "SUPER, F, togglefloating"
            "SUPER, G, fullscreen"
            "SUPER, O, fakefullscreen"
            "SUPER, P, togglesplit"

            (mvfocus "k" "u")
            (mvfocus "j" "d")
            (mvfocus "l" "r")
            (mvfocus "h" "l")
            (ws "left" "e-1")
            (ws "right" "e+1")
            (mvtows "left" "e-1")
            (mvtows "right" "e+1")
            (resizeactive "k" "0 -20")
            (resizeactive "j" "0 20")
            (resizeactive "l" "20 0")
            (resizeactive "h" "-20 0")
            (mvactive "k" "0 -20")
            (mvactive "j" "0 20")
            (mvactive "l" "20 0")
            (mvactive "h" "-20 0")
          ]
          ++ (map (i: ws (toString i) (toString i)) arr)
          ++ (map (i: mvtows (toString i) (toString i)) arr);

        bindle = [
          ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
          ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
          ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
          ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
          ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        ];

        bindl = [
          ",XF86AudioPlay,    exec, ${playerctl} play-pause"
          ",XF86AudioStop,    exec, ${playerctl} pause"
          ",XF86AudioPause,   exec, ${playerctl} pause"
          ",XF86AudioPrev,    exec, ${playerctl} previous"
          ",XF86AudioNext,    exec, ${playerctl} next"
          ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        ];

        bindm = [
          "SUPER, mouse:273, resizewindow"
          "SUPER, mouse:272, movewindow"
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

        animations = {
          enabled = "yes";
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        plugin = {
          overview = {
            centerAligned = true;
            hideTopLayers = true;
            hideOverlayLayers = true;
            showNewWorkspace = true;
            exitOnClick = true;
            exitOnSwitch = true;
            drawActiveWorkspace = true;
            reverseSwipe = true;
          };
          hyprbars = {
            bar_color = "rgb(2a2a2a)";
            bar_height = 28;
            col_text = "rgba(ffffffdd)";
            bar_text_size = 11;
            bar_text_font = "Ubuntu Nerd Font";

            buttons = {
              button_size = 0;
              "col.maximize" = "rgba(ffffff11)";
              "col.close" = "rgba(ff111133)";
            };
          };
        };
      };
    };
  };
}
