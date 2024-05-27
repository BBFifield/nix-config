{ pkgs, ... }:

let

  profilesPath = ".mozilla/firefox";

  extensionListNur = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    reddit-enhancement-suite
    betterttv
  ];

  extensionList = with builtins;
    let extension = shortID: uuid: {
      name = uuid;
      value = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortID}/latest.xpi";
        installation_mode = "force_installed";
      };
    };
    in listToAttrs
    [
      (extension "better-youtube-shorts" "{ac34afe8-3a2e-4201-b745-346c0cf6ec7d}")
      (extension "breezedarktheme" "{4e507435-d65f-4467-a2c0-16dbae24f288}")
    ];

  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.homepage" = "about:home";
    # New tab page
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.topSitesRows" = 2;
    # Functionality
    "general.autoScroll" = true;
    # Wavefox customizations
    "userChrome.DarkTheme.Tabs.Borders.Saturation.Medium.Enabled" = true;
    "userChrome.DarkTheme.Tabs.Shadows.Saturation.Medium.Enabled" = true;
    "userChrome.DragSpace.Left.Disabled" = true;
    "userChrome.Menu.Icons.Regular.Enabled" = true;
    "userChrome.Menu.Size.Compact.Enabled" = true;
    "userChrome.Tabs.Option6.Enabled" = true;
    "userChrome.Tabs.SelectedTabIndicator.Enabled" = true;
    # Appearance
    "browser.toolbars.bookmarks.visibility" = "never";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.non-native-titlebar-buttons.enabled" = false;
    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
  };
in
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value= true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DontCheckDefaultBrowser = true;
          SearchBar = "unified";

          /* ---- EXTENSIONS ---- */
          ExtensionSettings = extensionList;

          /* ---- PREFERENCES ---- */
          # Set preferences shared by all profiles.
          Preferences = {
            "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
            "widget.use-xdg-desktop-portal.file-picker" = 1;
          };
        };
      };


      profiles = {
        # fm2ch33d.default is primary profile
        testagain3 = {
          id = 0;               # 0 is the default profile; see also option "isDefault"
          inherit settings;
          extensions = extensionListNur;
        };
      };
    };
  };

  home.file."${profilesPath}/testagain3/chrome" = {
    source = pkgs.nur.repos.slaier.wavefox;
    recursive = true;
    force = true;
  };
}
