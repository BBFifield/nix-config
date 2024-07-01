# Plasma specific firefox settings

{ pkgs, lib, ... }:

{
  ExtensionSettings =
  {
    "{4e507435-d65f-4467-a2c0-16dbae24f288}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/breezedarktheme/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  settings = {
    # Appearance
    "extensions.activeThemeID" = lib.mkForce "{4e507435-d65f-4467-a2c0-16dbae24f288}"; #breezedarktheme
    # Wavefox customizations
    "userChrome.DarkTheme.Tabs.Borders.Saturation.Medium.Enabled" = true;
    "userChrome.DarkTheme.Tabs.Shadows.Saturation.Medium.Enabled" = false;
    "userChrome.DragSpace.Left.Disabled" = true;
    "userChrome.Menu.Icons.Regular.Enabled" = true;
    "userChrome.Menu.Size.Compact.Enabled" = true;
    "userChrome.Tabs.Option6.Enabled" = false;
    "userChrome.Tabs.Option7.Enabled" = true;
    "userChrome.Tabs.SelectedTabIndicator.Enabled" = true;
    "userChrome.Tabs.TabsOnBottom.Enabled" = true;
  };

  theme = {
    source = pkgs.nur.repos.slaier.wavefox;
    recursive = true;
    force = true;
  };
}
