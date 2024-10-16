{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.ironbar;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  options.hm.ironbar = {
    enable = lib.mkEnableOption "Enable ironbar statusbar.";
    hotload = lib.mkOption {
      type = (import ../../../submodules {inherit lib;}).hotload;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          playerctl
          swaynotificationcenter
        ];

        programs.ironbar = {
          enable = true;
          systemd = true;
          config = "";
          style = "";
        };
      }
      /*
        (
        lib.mkIf (config.hm.enableMutableConfigs && !config.hm.hotload.enable) {
          xdg.configFile."ironbar".source = mkOutOfStoreSymlink "${config.hm.projectPath}/bars/ironbar/config";
        }
      )
      */
      (
        lib.mkIf (config.hm.ironbar.hotload.enable) (let
          attrset = import ../../../themes/colorschemeInfo.nix;
          themeNames = lib.attrNames attrset;
          getVariantNames = theme: lib.attrNames attrset.${theme}.variants;

          mkColorPrefix = name: value: {
            name = "\$${name}";
            value = "#${value}";
          };

          unpacked = lib.concatMap (theme:
            lib.map (variant: {
              name = "${theme}_${variant}";
              value = let
                cognates = attrset.${theme}.cognates variant;
              in
                lib.map (cognateName: mkColorPrefix cognateName cognates.${cognateName}) (lib.attrNames cognates);
            }) (getVariantNames theme))
          themeNames;

          mkColorFile = name: value: {
            xdg.configFile."ironbar/ironbar_colorschemes/${name}.scss".text =
              lib.concatStringsSep "\n" (lib.map (cognate: "${cognate.name}: ${cognate.value};") value);
          };

          colorFiles = lib.mkMerge [
            (lib.foldl' (acc: item: {xdg.configFile = acc.xdg.configFile // item.xdg.configFile;}) {xdg.configFile = {};} (lib.attrValues (lib.mapAttrs (name: value: mkColorFile name value) (lib.listToAttrs unpacked))))
          ];
        in
          lib.mkMerge [
            {
              hm.hotload.scriptParts = {
                "3" = ''
                  rm "$directory/ironbar/_ironbar_colors.scss"
                  cp -rf "$directory/ironbar/ironbar_colorschemes/$1.scss" "$directory/ironbar/_ironbar_colors.scss"
                  sass "$directory/ironbar/style.scss" "$directory/ironbar/style.css"
                '';
                "6" = ''
                  ironbar reload
                '';
              };

              xdg.configFile."ironbar/_ironbar_colors.scss".text = let
                name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
              in
                lib.concatStringsSep "\n" (lib.map (cognate: "${cognate.name}: ${cognate.value};") ((lib.head (lib.filter (theme: name == theme.name) unpacked)).value));

              xdg.configFile."ironbar/style.scss".source = ./config/style.scss;
              xdg.configFile."ironbar/config.corn".source = ./config/config.corn;
              xdg.configFile."ironbar/sys_info.sh".source = ./config/sys_info.sh;
            }
            colorFiles
          ])
      )
    ]
  );
}
