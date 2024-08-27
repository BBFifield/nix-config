{ config, pkgs, lib, ... }: let
  cfg = config.hm.neovim.lunarvim;
in
with lib; {
  options.hm.neovim.lunarvim = {
    enable = mkEnableOption "Enable Lunarvim.";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Whether to configure {command}`lvim` as the default
          editor using the {env}`EDITOR` environment variable.
        '';    
    };
    extraConfig = mkOption {
      type = types.lines;
      default = '''';
      description = ''Custom configuration to put in ~/.config/lvim/config.lua'';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lunarvim
    ];
    home.sessionVariables = mkIf cfg.defaultEditor { EDITOR = "lvim"; };
    home.file.".config/lvim/config.lua".text = mkIf (cfg.extraConfig != '''') ''${cfg.extraConfig}'';
  };
}
