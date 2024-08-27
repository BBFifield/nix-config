{
  config,
  lib,
  osConfig,
  ...
}:
with lib; {
  options.hm.hyprland.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock.";
  };
  config = mkIf config.hm.hyprland.enable {
    programs.hyprlock = {
      enable = true;
      #https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
      /*
        extraConfig = ''
        ${builtins.readFile ./hyprlock.conf}
      '';
      sourceFirst = true;
      importantPrefixes = [

      ];
      */
      settings = let
        scale =
          {
            "1" = 2; # "1" is true
            "" = 1; # "" is false
          }
          .${builtins.toString osConfig.nixos.desktop.hidpi.enable};
      in {
        source = "$HOME/.config/hypr/hyprland.conf";

        "$accent" = "$mauve";
        "$accentAlpha" = "$mauveAlpha";
        "$font" = "FiraCode Nerd Font";

        # GENERAL
        general = {
          disable_loading_bar = true;
          hide_cursor = false;
        };

        # BACKGROUND
        background = {
          monitor = "";
          #path = "$HOME/.config/background";
          blur_passes = 0;
          color = "$base";
        };

        # LAYOUT
        label = [
          {
            monitor = "";
            text = "Layout: $LAYOUT";
            color = "$text";
            font_size = 25 * scale;
            font_family = "$font";
            position = "${builtins.toString (30 * scale)}, ${builtins.toString (-60 * scale)}";
            halign = "left";
            valign = "top";
          }
          # TIME
          {
            monitor = "";
            text = "$TIME";
            color = "$text";
            font_size = 90 * scale;
            font_family = "$font";
            position = "${builtins.toString (-30 * scale)}, 0";
            halign = "right";
            valign = "top";
          }
          # DATE
          {
            monitor = "";
            text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
            color = "$text";
            font_size = 25 * scale;
            font_family = "$font";
            position = "${builtins.toString (-30 * scale)}, ${builtins.toString (-150 * scale)}";
            halign = "right";
            valign = "top";
          }
        ];

        # USER AVATAR
        image = {
          monitor = "";
          path = "/var/lib/AccountsService/icons/$USER";
          size = 150 * scale;
          border_color = "$accent";
          position = "0, ${builtins.toString (75 * scale)}";
          halign = "center";
          valign = "center";
        };

        # INPUT FIELD
        input-field = {
          monitor = "";
          size = "${builtins.toString (300 * scale)}, ${builtins.toString (60 * scale)}";
          outline_thickness = 4;
          dots_size = 0.2 * scale;
          dots_spacing = 0.2 * scale;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = "false";
          placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          capslock_color = "$yellow";
          position = "0, ${builtins.toString (-47 * scale)}";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
