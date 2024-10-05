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
          Which package manager to use to manage your neovim plugins.
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

      xdg.configFile."nvim".source =
        if config.hm.enableMutableConfigs
        then mkOutOfStoreSymlink "${config.hm.projectPath}/editors/neovim/lazy"
        else pkgs.neovim-config; #"${config.hm.projectPath}/editors/neovim/lazy";
    };
  }
