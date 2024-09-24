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
    options.hm.neovim = {
      enable = mkEnableOption "Enable Neovim.";
      pluginManager = mkOption {
        type = with types; nullOr (enum ["lazy" "nix"]);
        default = null;
        description = ''
          Which package manager to use to manage your neovim plugins. This option is invalid when preset is set to lunarvim.
        '';
      };
    };
    config = mkIf cfg.enable {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };
      home.packages = with pkgs; [
        wl-clipboard # For system clipboard capabilities
        ripgrep # For BurntSushi/ripgrep
        gcc # For installing treesitter parsers
      ];

      #home.file."${config.hm.projectPath}/neovim/lazy".source = pkgs.neovim-config;

      xdg.configFile = mkMerge [
        (mkIf config.hm.enableMutableConfigs {
          "nvim".source = mkOutOfStoreSymlink "${config.hm.projectPath}/neovim/lazy";
        })
        (mkIf (!config.hm.enableMutableConfigs) {
          "nvim".source = pkgs.neovim-config; #"${config.hm.projectPath}/neovim/lazy";
        })
      ];
    };
  }
