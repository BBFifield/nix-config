{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.neovim;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  
in
  with lib; {
    imports = [./lunarvim];

    options.hm.neovim = {
      enable = mkEnableOption "Enable Neovim.";
      preset = mkOption {
        type = types.enum ["custom" "lunarvim"];
        default = "custom";
        description = "Which configuration preset to use.";
      };
      #enableMutableConfigs = mkEnableOption "Enable Neovim configuration files to be directly editable.";
    };
    config = mkIf cfg.enable (
      mkMerge [
        { 
          programs.neovim.enable = true; 
          home.packages = with pkgs; [
            wl-clipboard # For system clipboard capabilities
          ];
        }

        (mkIf (cfg.preset == "custom") {
          programs.neovim = {
            defaultEditor = true;

            plugins = with pkgs.vimPlugins; [
              alpha-nvim
              mini-nvim
              nvim-tree-lua
              nvim-web-devicons
              tokyonight-nvim
              telescope-nvim
              telescope-fzf-native-nvim
              lsp-zero-nvim
              gitsigns-nvim
              base16-nvim
              vim-nix
            ];
          };

          xdg.configFile = mkMerge [
            (mkIf config.hm.enableMutableConfigs {
              "nvim/init.lua".source = mkOutOfStoreSymlink "${config.hm.projectPath}/neovim/init.lua";
              "nvim/after/plugin/common.lua".source = mkOutOfStoreSymlink "${config.hm.projectPath}/neovim/common.lua";
              "nvim/after/plugin/config.lua".source = mkOutOfStoreSymlink "${config.hm.projectPath}/neovim/config.lua";
            })
            (mkIf (!config.hm.enableMutableConfigs) {
              "nvim/init.lua".source = "./init.lua";
              "nvim/after/plugin/common.lua".source = "./common.lua";
              "nvim/after/plugin/config.lua".source = "./config.lua";
            })
          ];
        })

       (mkIf (cfg.preset == "lunarvim") { 
          hm.neovim.lunarvim = mkIf (cfg.preset == "lunarvim") {
            enable = true;
            defaultEditor = true;
            extraConfig = ''${builtins.readFile ./common.lua}'' + ''${builtins.readFile ./lunarvim/config.lua}'';
          };
        })
      ]
    );
  }
