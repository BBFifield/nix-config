{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.neovim;
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
    };
    config = mkIf cfg.enable {
      programs.neovim = {
        enable = true;
        defaultEditor = mkIf (cfg.preset == "custom") true;
        extraLuaConfig = mkIf (cfg.preset == "custom") ''
          ${builtins.readFile ./common.lua}
        '';
      };

      home.packages = with pkgs; [
        wl-clipboard # For system clipboard capabilities
      ];

      hm.neovim.lunarvim = mkIf (cfg.preset == "lunarvim") {
        enable = true;
        defaultEditor = true;
        extraConfig = ''${builtins.readFile ./common.lua}'' + ''${builtins.readFile ./lunarvim/config.lua}'';
      };
    };
  }
