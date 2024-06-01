{ pkgs, ... }:

let

  profilesPath = ".mozilla/firefox";

  #Profile specific extensions
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    reddit-enhancement-suite
    betterttv
    darkreader
  ];

  #System-wide extensions. Will probably update to a list to concatenate with ${extensions} if I can figure out a way.
  ExtensionSettings = with builtins;
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

    "browser.uiCustomization.state"
      = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action\",\"addon_darkreader_org-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"unified-extensions-area\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":5}";

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.non-native-titlebar-buttons.enabled" = false;
    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
  };

  engines = {
    "Bing".metaData.hidden = true;
    "eBay".metaData.hidden = true;
    "Google".metaData.alias = "@g";
    "Wikipedia (en)".metaData.alias = "@w";

    "GitHub" = {
      urls = [{
        template = "https://github.com/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.fetchurl {
        url = "https://github.githubassets.com/favicons/favicon-dark.svg";
        sha256 = "1b474jhw71ppqpx9d0znsqinkh1g8pac7cavjilppckgzgsxvvxa";
      }}";
      definedAliases = [ "@gh" ];
    };

    "Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "channel"; value = "unstable"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    "NixOS Wiki" = {
      urls = [{
        template = "https://nixos.wiki/index.php";
        params = [ { name = "search"; value = "{searchTerms}"; }];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
      definedAliases = [ "@nw" ];
    };

    "Reddit" = {
      urls = [{
        template = "https://www.reddit.com/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.fetchurl {
        url = "https://www.redditstatic.com/accountmanager/favicon/favicon-512x512.png";
        sha256 = "0a173np89imayid67vfwi8rxp0r91rdm9cn2jc523mcbgdq96dg3";
      }}";
      definedAliases = [ "@r" ];
    };

    "Youtube" = {
      urls = [{
        template = "https://www.youtube.com/results";
        params = [ { name = "search_query"; value = "{searchTerms}"; }];
      }];
      icon = "${pkgs.fetchurl {
        url = "www.youtube.com/s/desktop/8498231a/img/favicon_144x144.png";
        sha256 = "1wpnxfch3fs1rwbizh7icqff6l4ljqpp660afbxj2n58pin603lm";
      }}";
      definedAliases = [ "@y" ];
    };
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
          inherit ExtensionSettings;

          /* ---- PREFERENCES ---- */
          # Set preferences shared by all profiles.
          Preferences = {
            "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
            "widget.use-xdg-desktop-portal.file-picker" = 1;
          };
        };
      };

      profiles = {
        testagain3 = {
          id = 0;               # 0 is the default profile; see also option "isDefault"
          inherit settings extensions;
          search = {
            force = true;
            default = "Google";
            order = [ "DuckDuckGo" "Google" ];
            inherit engines;
          };
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
