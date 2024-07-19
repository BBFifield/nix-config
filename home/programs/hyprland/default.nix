{ pkgs, config, lib, ... }:

with lib;
{

  options.hm.hyprland = {
	  enable = mkEnableOption "Enable hyprland configuration via home-manager";
  };

  config = mkIf config.hm.hyprland.enable {
    programs.qutebrowser.enable = true;

    home.packages = with pkgs; [
      walker
      alacritty
      swaynotificationcenter
      alacritty-theme
      tela-icon-theme
      awf
      nautilus
      fuzzel
    ];

    services.hypridle =  {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";      # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 600  ;                          # 5min
            on-timeout = "loginctl lock-session";    # lock screen when timeout has passed
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
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
            "hyprland"
            "gtk"
          ];
        };
      }; 
    };
    
    home.pointerCursor = {
      gtk.enable = true;
      package = (pkgs.callPackage ../../../pkgs/icons {}).breezeXcursor;
      name = "BreezeX-Dark";
      size = 28;
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };
      iconTheme = {
        name = "Tela";
      };
      font = {
        name = "Sans";
        size = lib.mkForce 10;
      };
    };
  
	  wayland.windowManager.hyprland = {
      enable = true;
      /*plugins = [
        inputs.packages.${pkgs.system}.Hyprspace
      ];*/

      settings = {
        # You can split this configuration into multiple files
        # Create your files separately and then link them to this file like this:
        # source = ~/.config/hypr/myColors.conf

        ################
        ### MONITORS ###
        ################

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = ",preferred,auto,2";


        ###################
        ### MY PROGRAMS ###
        ###################

        # See https://wiki.hyprland.org/Configuring/Keywords/

        # Set programs that you use
        "$terminal" = "alacritty";
        "$fileManager" = "nautilus";
        "$wallpaperUtils" = "waypaper";
        "$menu" = "walker";


        #################
        ### AUTOSTART ###
        #################

        # Autostart necessary processes (like notifications daemons, status bars, etc.)
        # Or execute your favorite apps at launch like this:

        # exec-once = nm-applet &
        exec-once = [
                      "gBar bar HDMI-A-1"
                      #"ags"
                      "wpaperd"
                      "swaynotificationcenter"     
                    ];


        #############################
        ### ENVIRONMENT VARIABLES ###
        #############################

        # See https://wiki.hyprland.org/Configuring/Environment-variables/

        env =
          [
            "XCURSOR_SIZE,28"
            "HYPRCURSOR_SIZE,28"
            "HYPRCURSOR_THEME,BreezeX-Dark"
            "XCURSOR_THEME,BreezeX-Dark"

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


        #####################
        ### LOOK AND FEEL ###
        #####################

        # Refer to https://wiki.hyprland.org/Configuring/Variables/

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          gaps_in = 5;
          gaps_out = 15;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(3eff00ee) rgba(cb00ffee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };

        xwayland = {
          force_zero_scaling = true;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 0.9;

          drop_shadow = true;
          shadow_range = 6;
          shadow_render_power = 1;
          #shadow_offset = "3 3";
          
          "col.shadow" = "rgba(1a1a1aee)";

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 4;
            passes = 3;

            vibrancy = 0.1696;

            popups = true;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"
           "linearBezier, 0, 0, 1, 1"];

          animation =
            [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 40, linearBezier, loop"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
        };

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
        };

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        master = {
          new_status = "master";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          force_default_wallpaper = 1; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          #enable_swallow = true;
        };


        #############
        ### INPUT ###
        #############

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          # This changes window focus
          follow_mouse = 2;
          

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
        /*device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };*/

        ####################
        ### KEYBINDINGSS ###
        ####################

        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind =
          [
            "$mainMod, T, exec, $terminal"
            "$mainMod, F, exec, $fileManager"
            "$mainMod, W, exec, $wallpaperUtils"
            "$mainMod, R, exec, $menu"

            "$mainMod, K, killactive,"
            "$mainMod, Q, exit,"
            
            "$mainMod, V, togglefloating,"
            "$mainMod, P, pseudo," # dwindle
            "$mainMod, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"

        # Cycle to next or previous wallpaper with wpaperd
            "$mainMod SHIFT, right, exec, wpaperctl next"
            "$mainMod SHIFT, left, exec, wpaperctl previous" # Doesn't work for some reason
          ]

        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      ++ (
            builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
          )

      ++ [
        # Example special workspace (scratchpad)
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
          
        # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
      ];
      
      bindm = [  
        # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];


        ##############################
        ### WINDOWS AND WORKSPACES ###
        ##############################

        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

        # Example windowrule v1
        # windowrule = float, ^(kitty)$

        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

        windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
      };
	  };
  };
}
