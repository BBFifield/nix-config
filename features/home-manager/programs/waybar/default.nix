{
  pkgs,
  config,
  lib,
  ...
}: {
  options.hm.waybar = {
    enable = lib.mkEnableOption "Enable waybar";
  };

  config = lib.mkIf config.hm.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = [
        {
          height = 30;
          layer = "top";
          position = "top";
          tray = {spacing = 10;};
          modules-center = ["sway/window"];
          modules-left = ["sway/workspaces" "sway/mode"];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "clock"
            "tray"
          ];

          clock = {
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = {format = "{}% ";};
          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
            format-linked = "{ifname} (No IP) ";
            format-wifi = "{essid} ({signalStrength}%) ";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = ["" "" ""];
              handsfree = "";
              headphones = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            on-click = "pavucontrol";
          };
          "sway/mode" = {format = ''<span style="italic">{}</span>'';};
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
          };
        }
      ];
      style = ''
        ${builtins.readFile ./style.css}
      '';
    };
  };
}
