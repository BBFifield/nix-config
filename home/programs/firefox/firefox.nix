{ pkgs, ... }:

let

  profilesPath = ".mozilla/firefox";

  extensionSet = {
    # ublock
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    # RES
    "jid1-xUfzOsOFlzSOXg@jetpack" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi";
      installation_mode = "force_installed";
    };
    # Better Youtube Shorts
    "{ac34afe8-3a2e-4201-b745-346c0cf6ec7d}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/better-youtube-shorts/latest.xpi";
      installation_mode = "force_installed";
    };
    # Breeze Dark Theme
    "{4e507435-d65f-4467-a2c0-16dbae24f288}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/breezedarktheme/latest.xpi";
      installation_mode = "force_installed";
    };
  };

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
          ExtensionSettings = extensionSet;

          /* ---- PREFERENCES ---- */
          # Set preferences shared by all profiles.
          Preferences = {
            "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          };
        };
      };


      profiles = {
        # fm2ch33d.default is primary profile
        testagain3 = {
          id = 0;               # 0 is the default profile; see also option "isDefault"
          inherit settings;
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
