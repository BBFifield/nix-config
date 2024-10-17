{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.yazi;
  tomlFormat = pkgs.formats.toml {};
in {
  options.hm.yazi = {
    enable = lib.mkEnableOption "Enable Yazi, the terminal file manager.";
    hotload = lib.mkOption {
      type = (import ../../submodules {inherit lib;}).hotload;
    };
  };

  config = let
    attrset = import ../../themes/colorschemeInfo.nix;
    themeNames = lib.attrNames attrset;
    getVariantNames = theme: lib.attrNames attrset.${theme}.variants;
  in
    lib.mkMerge [
      (
        lib.mkIf (cfg.hotload.enable)
        (
          let
            mkThemeFile = theme: variant: {
              xdg.configFile."yazi/themes/${theme}_${variant}.toml" = {
                source = tomlFormat.generate "theme" {
                  flavor = {
                    use = "${theme}-${variant}";
                  };
                };
              };
            };

            themeFilesList = lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  #result = builtins.pathExists "${pkgs.yazi-flavors}/${theme}-${variant}.yazi";
                  gitpath = builtins.fetchGit {
                    url = "https://github.com/yazi-rs/flavors.git";
                    ref = "main";
                  };
                  result = builtins.pathExists "${gitpath}/${theme}-${variant}.yazi";
                  file =
                    if result
                    then (mkThemeFile theme variant)
                    else null;
                in
                  file
              ) (getVariantNames theme))
            themeNames);

            themeFiles = lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} themeFilesList;
          in
            lib.mkMerge [
              {
                hm.hotload.scriptParts = {
                  "5" = ''
                    rm $directory/yazi/theme.toml
                    cp -rf $directory/yazi/themes/$1.toml $directory/yazi/theme.toml
                  '';
                };
              }
              themeFiles
            ]
        )
      )
      # This file is created regardless
      {
        xdg.configFile."yazi/theme.toml" = {
          source = tomlFormat.generate "theme" {
            flavor.use = "${config.hm.theme.colorscheme.name}-${config.hm.theme.colorscheme.variant}";
          };
        };
      }
      {
        home.packages = with pkgs; [
          ueberzugpp
        ];
        programs.yazi = {
          enable = true;
          enableBashIntegration = true;
          flavors = lib.mkMerge [
            (lib.listToAttrs (lib.filter (item: item != null) (lib.concatMap (theme:
              lib.map (
                variant: let
                  result = builtins.pathExists "${pkgs.yazi-flavors}/${theme}-${variant}.yazi";
                  flavor =
                    if result
                    then {
                      name = "${theme}-${variant}";
                      value = "${pkgs.yazi-flavors}/${theme}-${variant}.yazi";
                    }
                    else null;
                in
                  flavor
              ) (getVariantNames theme))
            themeNames)))
          ];

          # "catppuccin-${cfg.variant}" = "${pkgs.yazi-flavors}/catppuccin-${cfg.variant}.yazi";
          settings = {
            manager = {
              show_hidden = true;
            };
          };
        };
      }
    ];
}
