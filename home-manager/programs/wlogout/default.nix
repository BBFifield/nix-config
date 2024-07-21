{ config, lib, }:
{
  options.hm.wlogout = {
    emable = lib.mkEnableOption "Enable wlogout."
  };

  config = lib.mkIf config.hm.wlogout {
    programs.wlogout = {
      enable = true;

      style = ''
        ${builtins.readFile ./style_1.css}
      '';

      layout = [
        {
          label = "lock";
          action = "swaylock";
          text = "Lock";
          keybind = "l";
        }

        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }

        {
          label = "suspend";
          action = "swaylock -f && systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }

        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }

        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }

        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
  };
}