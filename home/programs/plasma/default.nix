{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      #lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      cursor.theme = "breeze_cursors";
      iconTheme = "Breeze-Round-Chameleon Dark Icons";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/contents/images_dark/3840x2160.png";

      windowDecorations = {
        library="org.kde.klassy";
        theme="Klassy";
      };

      splashScreen = {
        engine = "none";
        theme = "None";
      };
    };

    kwin = {
      virtualDesktops = {
        rows = 1;
        number = 2;
      };
    };

    panels = [
      {
        location = "top";
        height = 27;
        widgets = [
          {  name = "org.kde.plasma.ginti";  }
          {  name = "org.kde.plasma.appmenu";  }
          {  name ="org.kde.plasma.panelspacer";  }
          {
            name = "org.kde.windowtitle";
            config.General = {
              boldFont = "false";
              showIcon = "false";
              fontSize = "13";
            };
          }
          {
            name ="org.kde.plasma.panelspacer";
          }
          {
            name = "com.github.antroids.application-title-bar";
            config.Appearance = {
              widgetButtonsIconsTheme="Breeze";
              widgetElements = "windowMinimizeButton,windowMaximizeButton,windowCloseButton";
              widgetElementsMaximized = "windowMinimizeButton,windowMaximizeButton,windowCloseButton";
              widgetElementsDisabledMode = "HideKeepSpace";
              widgetHorizontalAlignment = "2";
              widgetMargins = "0";
              widgetSpacing = "1";
            };
            config.Behaviour = {
              widgetActiveTaskFilterNotMaximized ="true";
            };
          }
        ];
      }
      {
        location = "bottom";
        floating = true;
        height = 48;
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default.
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:org.kde.kate.desktop"
              ];
            };
          }
          {
            name = "luisbocanegra.panel.colorizer";
            config.General = {
              colorMode="2";
              customColors="";
              enableCustomPadding="true";
              fgColorEnabled="true";
              fgShadowColor="#8a000000";
              fgShadowEnabled="true";
              fgShadowRadius="5";
              fgShadowX="2";
              fgShadowY="2";
              hideWidget="true";
              opacity="1";
              panelBgColorMode="1";
              panelBgColorModeTheme="9";
              panelBgColorModeThemeVariant="1";
              panelBgEnabled="true";
              panelBgOpacity="0";
              panelOutlineOpacity="0.15";
              panelOutlineWidth="1";
              panelShadowSize="7";
              panelShadowX="4";
              panelShadowY="4";
              panelWidgets="org.kde.plasma.kickoff,Application Launcher,nix-snowflake|org.kde.plasma.icontasks,Icons-only Task Manager,preferences-system-windows|luisbocanegra.panel.colorizer,Panel colorizer,desktop|org.kde.plasma.systemtray,System Tray,preferences-desktop-notification|org.kde.plasma.digitalclock,Digital Clock,preferences-system-time|org.kde.plasma.showdesktop,Peek at Desktop,user-desktop-symbolic";
              panelWidgetsWithTray="org.kde.plasma.kickoff,Application Launcher,nix-snowflake|org.kde.plasma.icontasks,Icons-only Task Manager,preferences-system-windows|luisbocanegra.panel.colorizer,Panel colorizer,desktop|org.kde.plasma.clipboard,Clipboard,klipper-symbolic|org.kde.plasma.volume,Audio Volume,audio-volume-high-symbolic|org.kde.plasma.bluetooth,Bluetooth,network-bluetooth-activated-symbolic|org.kde.plasma.devicenotifier,Disks & Devices,drive-removable-media-usb-symbolic|org.kde.plasma.networkmanagement,Networks,network-wired-activated-symbolic|kded6,Get Plasma Browser Integration,plasma-browser-integration|org.kde.plasma.digitalclock,Digital Clock,preferences-system-time|org.kde.plasma.showdesktop,Peek at Desktop,user-desktop-symbolic";
              widgetBgEnabled="true";
              widgetShadowColor="#000000";
            };
          }
          {
            systemTray.items = {
              shown = [

              ];
              hidden = [

              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
          {
            name = "org.kde.plasma.showdesktop";
          }
        ];
      }
    ];

    configFile = {
      kdeGlobals.Kscreen.ScaleFactor = 2;
      breezerc.Style.MenuOpacity = 70;

      kscreenlockerrc.Daemon = {
        LockGrace = 60;
        Timeout = 30;
      };
      kwinrc = {
        "org.kde.kdecoration2" = {
          BorderSize="None";
          BorderSizeAuto=false;
        };
        Windows = {
          BorderlessMaximizedWindows = true;
        };
        Xwayland.Scale = 1;
      };
    };
  };
}
