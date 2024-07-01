 # Gnome specific firefox settings

{ pkgs, lib, ... }:

{

  ExtensionSettings = {};

  settings = {
    # Appearance settings
    "browser.tabs.inTitlebar" = lib.mkForce 1;
    "browser.uiCustomization.state" = 
      lib.mkForce ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","addon_darkreader_org-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","idcac-pub_guus_ninja-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","new-tab-button","urlbar-container","downloads-button","unified-extensions-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","idcac-pub_guus_ninja-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action"],"dirtyAreaCache":["nav-bar","unified-extensions-area","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":20,"newElementCount":6}'';
    "widget.gtk.non-native-titlebar-buttons.enabled" = lib.mkForce true;
    # Firefox gnome theme settings
    "gnomeTheme.hideSingleTab" = true;
    "gnomeTheme.bookmarksToolbarUnderTabs" = true;
    "gnomeTheme.normalWidthTabs" = false;
    "gnomeTheme.tabsAsHeaderbar" = false;
    "svg.context-properties.content.enabled" = true;
  };

  theme = {
    source = pkgs.fetchFromGitHub {
      owner = "rafaelmardojai";
      repo = "firefox-gnome-theme";
      rev = "9b04085";
      hash = "sha256-7bzYqMpjxORueIt8F3zC8KNygKaXUmnPzFWSXwOWnvI=";
    };
    recursive = true;
    force = true;
  };
}
