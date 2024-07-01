{ pkgs, lib, desktopEnv, ... }:

let

  profilesPath = ".mozilla/firefox";

  #Profile specific extensions
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    reddit-enhancement-suite
    betterttv
    darkreader
    istilldontcareaboutcookies
    privacy-badger
    unpaywall
  ];

  #System-wide extensions. Will probably update to a list to concatenate with ${extensions} if I can figure out a way.
  ExtensionSettings = (with builtins;
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
      ]) // (import ./${desktopEnv}.nix {inherit pkgs lib;}).ExtensionSettings;

  # Couldn't use builtins.toJSON by itself to convert because it would put label before url
  pinnedShortcuts = with builtins;
    let shortcut = url: label: concatStringsSep ","
      [
        (lib.strings.removeSuffix "}" (builtins.toJSON {"url" = url;}))
        (lib.strings.removePrefix "{" (builtins.toJSON {"label" = label;}))
      ];
    in concatStringsSep ","
      [
        # Each element in the list is the returned string of the function "shortcut",
        # defined in the let block above, when given the url and label in that order.
        (shortcut "https://www.youtube.com/" "Youtube")
        (shortcut "https://github.com/BBFifield" "Github")
        (shortcut "https://mapleleafshotstove.com" "MLHS")
        (shortcut "https://yaleclimateconnections.org/topic/eye-on-the-storm" "YCC")
        (shortcut "https://www.reddit.com/r/leafs/" "/r/leafs")
      ];

  settings = {
    # Functionality
    "general.autoScroll" = true;
    "browser.newtabpage.pinned" = "[${pinnedShortcuts}]";
    # Appearance
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.tabs.inTitlebar" = lib.mkDefault 0;
    "browser.uiCustomization.state"
      = lib.mkDefault ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","addon_darkreader_org-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action"],"dirtyAreaCache":["nav-bar","unified-extensions-area","PersonalToolbar","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":5}'';
    "extensions.activeThemeID" = lib.mkDefault	"default-theme@mozilla.org";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.non-native-titlebar-buttons.enabled" = lib.mkDefault false;
    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
  } // (import ./${desktopEnv}.nix {inherit pkgs lib;}).settings;


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
        params = [{ name = "search"; value = "{searchTerms}"; }];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
      definedAliases = [ "@nw" ];
    };

    "Home Manager Options" = {
      urls = [{
        template = "https://home-manager-options.extranix.com";
        params = [
          { name = "query"; value = "{searchTerms}"; }
          { name = "release"; value = "master"; }
        ];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@hm" ];
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

in {
  programs = {
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          # Default download directory
          DefaultDownloadDirectory ="./Downloads";
          DisableAppUpdate = true;
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
            # Pointless on nix
            "browser.aboutConfig.showWarning" = false;
            "browser.contentblocking.category" = { Value = "standard"; Status = "locked"; };
            "browser.startup.homepage" = "about:home";
            # New tab page
            "browser.newtabpage.activity-stream.default.sites" = "";
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.topSitesRows" = 2;
            # File-picker
            "widget.use-xdg-desktop-portal.file-picker" = 1;
          };
        };
      };

      profiles = {
        default = {
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

  home.file."${profilesPath}/default/chrome" = (import ./${desktopEnv}.nix { inherit pkgs lib; }).theme;
}
