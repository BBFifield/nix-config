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
      pluginManager = mkOption {
        type = with types; nullOr (enum [ "lazy" "nix" ]);
        default = null;
        description = ''
          Which package manager to use to manage your neovim plugins. This option is invalid when preset is set to lunarvim.
        '';
      };
    };
    config = mkIf cfg.enable (
      mkMerge [
        { 
          programs.neovim.enable = true; 
          home.packages = with pkgs; [
            wl-clipboard # For system clipboard capabilities
            ripgrep # For BurntSushi/ripgrep
          ];
        }

        (mkIf (cfg.preset == "custom") {
          programs.neovim = {
            defaultEditor = true;

            plugins = with pkgs.vimPlugins; [
              #nvim-lspconfig
              #vim-nix
            ] 
            /*++ optionals (cfg.pluginManager == "nix") [
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
            ]*/;
          };

          #home.file."${config.hm.projectPath}/neovim/lazy".source = pkgs.neovim-config;

          xdg.configFile = mkMerge [
            (mkIf config.hm.enableMutableConfigs {
              "nvim".source = mkOutOfStoreSymlink "${config.hm.projectPath}/neovim/lazy";
            })
            (mkIf (!config.hm.enableMutableConfigs) {
              "nvim".source = pkgs.neovim-config; #"${config.hm.projectPath}/neovim/lazy";
            })
          ];
        })

        (mkIf (cfg.preset == "lunarvim") { 
          warnings = 
            if cfg.pluginManager != null
            then [
              ''            You have set a plugin manager. This will have no effect with Lunar as the preset since Lazy is already used by default
                          and NixOS or home-manager have no options to install plugins for this Neovim distro. I don't feel like implementing options that symlink
                          the plugins to Lunar's directory. 
              ''
            ]
            else [];
          hm.neovim.lunarvim = {
            enable = true;
            defaultEditor = true;
            extraConfig = ''${builtins.readFile ./lunarvim/keymaps.lua}'' + ''${builtins.readFile ./lunarvim/config.lua}'';
          };
        })
      ]
    );
  }
