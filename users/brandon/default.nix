{
  pkgs,
  osConfig,
  lib,
  ...
}: let
  username = "brandon";
  homeDirectory = "/home/${username}";

  defaultPkgs = with pkgs; [
    git
    gh
    efibootmgr
    gptfdisk
    discord
    _1password-gui
    shellcheck
    arduino-ide
    alejandra
    nil
    lua-language-server
    stylua
    prettierd
    dart-sass
  ];
in {
  imports = [../../features/home-manager];

  # lib.mergeAttrsList or // does not work here instead of lib.mkMerge because firefox for example, is
  # defined in both the base config and one of the optionals to be merged. The attribute sets only merge nicely if both contain distinct attribute keys,
  # so in this case firefox.enable = false (implied and the default value) from the optional set overrides the earlier declaration. "lib.mkMerge" otoh, merges
  # explicitly declared values and ignores "implied".
  hm = let
    sysCfg = osConfig.nixos;
  in
    lib.mkMerge [
      ###### BASE CONFIG ######
      {
        firefox.enable = true;
        vscodium.enable = true;
        neovim = {
          enable = true;
          pluginManager = "lazy";
        };
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          fonts.defaultMonospace = sysCfg.desktop.theme.fonts.defaultMonospace;
          cursorTheme = {
            name = sysCfg.desktop.theme.cursorTheme.name;
            size = sysCfg.desktop.theme.cursorTheme.size;
          };
        };
      }
      (lib.optionalAttrs (sysCfg.project.enableMutableConfigs) {
        enableMutableConfigs = true;
        projectPath = sysCfg.project.path + "/features/home-manager/programs";
      })
      ###### PLASMA CONFIG ######
      (lib.optionalAttrs (sysCfg.desktop.plasma.enable) {
        firefox.style = "plasma";
        plasma.enable = true;
        konsole.enable = true;
        klassy.enable = true;
        kate.enable = true;
        theme = {
          gtkTheme.name = "Breeze";
          iconTheme = ''"Breeze-Round-Chameleon Dark Icons"'';
        };
      })
      ###### GNOME-SHELL CONFIG ######
      (lib.optionalAttrs (sysCfg.desktop.gnome.enable) {
        firefox.style = "gnome";
        gnome-shell.enable = true;
        dconf.enable = true;
        vscodium.theme = "gnome";
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          iconTheme = "MoreWaita";
        };
      })
      ###### HYPRLAND CONFIG ######
      (lib.optionalAttrs (osConfig.nixos.desktop.hyprland.enable) {
        firefox.style = "gnome";
        dconf.enable = true;
        theme = {
          gtkTheme.name = "adw-gtk3-dark";
          iconTheme = "MoreWaita";
          colorScheme = {
            name = "catppuccin";
            variant = "macchiato";
          };
        };
        hyprland = lib.mkMerge [
          {enable = true;}
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "vanilla") {shell = "vanilla";})
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "asztal") {shell = "asztal";})
          (lib.optionalAttrs (sysCfg.desktop.hyprland.shell == "hyprpanel") {shell = "hyprpanel";})
        ];
        vscodium.theme = "gnome";
      })
    ];

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "24.11";
    packages =
      defaultPkgs;
  };

  programs.git = {
    enable = true;
    userName = "BBFifield";
    userEmail = "bb.fifield@gmail.com";
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
}
