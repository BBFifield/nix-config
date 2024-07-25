# Credit goes to github:Cu3P042 for the code snippet which changes the users' avatar in sddm.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
  mkMerge [
    {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          Theme = {
            CursorSize = 28;
            CursorTheme = "BreezeX-Dark";

            # SDDM theoretically supports getting user icons from AccountsService (which
            # we have set up), but implements it poorly. Instead of actually querying
            # AccountsService for the icon, it hardcodes the path where it will typically
            # place the icons. Since we place them elsewhere, we need to set up icons for
            # SDDM seperately.
            FacesDir = let
              usersWithIcons = lib.filterAttrs (_: value: value.icon != null) config.users.users;
              # Icons need to end in .face.icon
              iconLinks = lib.mapAttrsToList (name: value: "ln -s ${value.icon} ${name}.face.icon") usersWithIcons;
              icons = pkgs.runCommand "user-icons" {} ''
                mkdir -p $out
                cd $out
                ${lib.concatStringsSep "\n" iconLinks}
              '';
            in "${icons}";
          };
        };
      };
    }

    (mkIf (config.desktop.session == "plasma") {
      environment.systemPackages = with pkgs.kdePackages; [sddm-kcm];
      services.displayManager.sddm = {
        wayland.compositor = "kwin";
        theme = "breeze";
      };
    })
    (mkIf (config.desktop.session == "hyprland") {
      environment.systemPackages = with pkgs; [sddm-chili-theme];
      services.displayManager.sddm = {
        wayland.compositor = "weston";
        theme = "chili";
        settings = {
          General = {
            GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
          };
        };
      };
    })
  ]
