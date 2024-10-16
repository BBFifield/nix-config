{
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    (lib.concatMap import [./programs])
    ++ [./themes];

  options.hm = {
    enableMutableConfigs = lib.mkEnableOption "Enable configs to be directly modifiable.";
    hotload = lib.mkOption {
      type = (import ./submodules {inherit lib;}).hotload;
    };
    projectPath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Where the project is stored before evaluation. This option is used to update configuration files symlinked from the project to
        wherever they are typically put without having to rebuild the entire configuration.
      '';
    };
    hidpi.enable = lib.mkEnableOption "Enable hidpi (which just makes the scale 2x in relevant parts of the configuration).";
  };

  config = {
    home.packages = let
      parts =
        {
          "1" = ''
            #!/usr/bin/env bash
            directory=${config.home.homeDirectory}/.config
            current_colorscheme="$1"
            switch_config() {
          '';
          "4" = ''
            }
              if [ "$(ls -1 "$directory/hypr/hyprland_colorschemes" | wc -l)" -le 1 ]; then
                exit 1
              else
                next_colorscheme=$(ls -1 "$directory/hypr/hyprland_colorschemes" | sed -n "/$current_colorscheme/{n;p}" | sed 's/\.[^.]*$//')
                if [[ -z "$next_colorscheme" ]]; then
                  next_colorscheme=$(ls -1 "$directory/hypr/hyprland_colorschemes" | sed -n '1p' | sed 's/\.[^.]*$//')
                fi
              fi
              switch_config "$next_colorscheme"
          '';
        }
        // config.hm.hotload.scriptParts;

      sortedList = builtins.trace (lib.sort (a: b: a.name < b.name) (lib.attrsToList parts)) (lib.sort (a: b: a.name < b.name) (lib.attrsToList parts));

      scriptList = lib.map (part: part.value) sortedList;
    in [
      (pkgs.writeTextFile {
        name = "switch-colorscheme";
        text = pkgs.lib.concatStringsSep "\n" scriptList;
        executable = true;
        destination = "/bin/switch-colorscheme";
      })
    ];
  };
}
