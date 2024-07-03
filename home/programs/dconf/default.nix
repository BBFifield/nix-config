# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  pkgs,
  lib,
  config,
  ...
}:
with lib.hm.gvariant; {
  options.hm.dconf = {
    enable = lib.mkEnableOption "Enable dconf configuration";
  };

  config = lib.mkIf config.hm.dconf.enable {
    dconf.settings = {
      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };

      "org/gnome/desktop/a11y/applications" = {
        screen-reader-enabled = false;
      };

      "org/gnome/desktop/background" = {
        picture-options = "zoom";
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/amber-d.jxl";
      };

      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        color-scheme = "prefer-dark";
        enable-animations = true;
        font-name = "Noto Sans,  10";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Adwaita";
        scaling-factor = mkUint32 2;
        text-scaling-factor = 1.0;
        toolbar-style = "text";
      };

      "org/gnome/TextEditor" = {
        show-line-numbers = true;
        style-schema = "kate-dark";
        show-map = "true";
        style-scheme = "kate-dark";
        use-system-font = true;
      };

      "org/gnome/builder/editor" = {
        map-policy = "always";
        style-scheme-name = "kate-dark";
      };

      "org/gnome/builder/editor/language/nix" = {
        tab-width = 2;
      };

      "org/gnome/desktop/screensaver" = {
        picture-options = "zoom";
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
      };

      "org/gnome/desktop/search-providers" = {
        disabled = [];
        sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "icon:minimize,maximize,close";
      };

      "org/gnome/epiphany" = {
        ask-for-default = false;
      };

      "org/gnome/gedit/state/window" = {
        bottom-panel-active-page = "GeditExternalToolsShellOutput";
        bottom-panel-size = 139;
        side-panel-active-page = "GeditWindowDocumentsPanel";
        side-panel-size = 200;
        size = mkTuple [900 700];
        state = 87168;
      };

      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small-plus";
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "icon-view";
        migrated-gtk-settings = true;
        search-filter-time-type = "last_modified";
      };

      "org/gnome/nautilus/window-state" = {
        initial-size = mkTuple [890 550];
      };

      "org/gnome/shell" = {
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          gsconnect.extensionUuid
        ];
        favorite-apps = ["firefox.desktop" "1password.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Console.desktop" "org.gnome.TextEditor.desktop" "org.gnome.Builder.desktop"];
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = true;
        brightness = 0.6;
        override-background-dynamically = true;
        pipeline = "pipeline_default";
        sigma = 30;
        style-panel = 0;
        unblur-in-overview = true;
      };

      "org/gnome/shell/world-clocks" = {
        locations = [];
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "interactive";
        sleep-inactive-ac-timeout = 3600;
      };
    };
  };
}
