{ pkgs, lib, ... }:

let
  username = "brandon";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  plasmoidPkgs = (pkgs.callPackage ../plasmoids.nix {});

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    home-manager
    discord
    _1password-gui
    vivaldi
    vivaldi-ffmpeg-codecs
    vscode
  ];

  /*kdePackages = with pkgs.kdePackages; [
    sddm-kcm
    partitionmanager
    kpmcore
  ];*/
in
{

  imports = lib.concatMap import [
    ./programs
  ];

  #programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    packages = defaultPkgs ++ (with plasmoidPkgs; [window-title-applet]);

  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";


  /************************** Plasma Config **********************************************/

  programs.plasma = {
    enable = true;
    overrideConfig = true;
    #
    # Some high-level settings:
    #
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursorTheme = "breeze_cursors";
      iconTheme = "breeze-dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/contents/images_dark/3840x2160.png";
    };

    panels = [
      /*{
        location = "top";
        height = 27;
        widgets = [
          {
            name = "org.kde.plasma.appmenu";
          }
        ];
      }*/
      {
        location = "bottom";
        floating = true;
        height = 44;
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
      ksplashrc.KSplash = {
        Engine = "none";
        Theme = "None";
      };

    };
  };
}
