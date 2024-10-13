{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.hyprland;
  yt = pkgs.writeShellScript "yt" ''
    notify-send "Opening video" "$(wl-paste)"
    mpv "$(wl-paste)"
  '';

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";

  theme = {
    name = config.hm.theme.gtkTheme.name;
  };
  cursorTheme = {
    name = config.hm.theme.cursorTheme.name;
    size = config.hm.theme.cursorTheme.size;
    package = config.hm.theme.cursorTheme.package;
  };
  iconTheme = {
    name = config.hm.theme.iconTheme;
  };
  font = {
    name = "Cantarell"; #"Sans";
    size = lib.mkForce 10;
  };

  settings = {
    exec-once = [
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
      "workspace 3, ^(org.gnome.Nautilus)$"
      "workspace 2, title:Firefox"
      "workspace 1, ^(VSCodium)$"
    ];

    windowrulev2 = [
      /*
        won't match
      "workspace 3, initialTitle:^(.*Yazi.*)$, class:^(.Alacritty.*)$"
      "workspace 1, initialTitle:^(.*Alacritty.*)$, class:^(.*Alacritty.*)$, title:^(.*NVIM.*)$"
      */
      "opacity 0.95 override 0.9 override, class:^(Alacritty)$"
    ];

    bind = let
      binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
      mvfocus = binding "SUPER" "movefocus";
      ws = binding "SUPER" "workspace";
      resizeactive = binding "SUPER CTRL" "resizeactive";
      mvactive = binding "SUPER ALT" "moveactive";
      mvtows = binding "SUPER SHIFT" "movetoworkspace";
      arr = [1 2 3 4 5 6 7];
    in
      [
        "SUPER, W, exec, firefox"
        "SUPER, F, exec, [workspace 3] alacritty -e yazi"
        "SUPER, E, exec, alacritty"
        "SUPER, C, exec, [workspace 1] alacritty -e nvim"

        # youtube
        ", XF86Launch1,  exec, ${yt}"

        "ALT, Tab, focuscurrentorlast"
        "CTRL ALT, Delete, exit"
        "ALT, Q, killactive"
        #"SUPER, F, togglefloating"
        "SUPER, G, fullscreen"
        "SUPER CTRL, P, togglesplit"

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
      rounding = 10;
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
        size = 10;
        passes = 3;
        new_optimizations = "on";
        noise = 0.01;
        contrast = 0.9;
        brightness = 0.9;
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
  };
in {
  imports = [
    ./shell
    ./hyprlock
  ];

  options.hm.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration via home-manager";
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        xdg.desktopEntries = {
          "org.gnome.Settings" = {
            name = "Settings";
            comment = "Gnome Control Center";
            icon = "org.gnome.Settings";
            exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
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
            adw-gtk3
            loupe
            baobab
            gnome-system-monitor
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
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
          ];
          config.common.default = [
            "hyprland"
            "gtk"
          ];
        };

        services.hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "./start_hyprlock.sh"; # avoid starting multiple hyprlock instances.
              before_sleep_cmd = "./start_hyprlock.sh";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
            };

            listener = [
              {
                timeout = 9000;
                on-timeout = "./start_hyprlock.sh";
              }
              {
                timeout = 12000;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };
      }
      {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd = {
            enable = true;
            variables = [
              "--all"
            ];
          };
          xwayland.enable = true;
          inherit settings;
        };
      }
    ]
  );
}
