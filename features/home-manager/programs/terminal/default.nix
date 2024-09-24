{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.terminal;
in {
  imports = [
    ./alacritty
    ./starship
    ./konsole
  ];

  options.hm.terminal = {
    default = mkOption {
      type = with types; nullOr enum ["alacritty" "konsole"];
      default = "alacritty";
    };
    shell = mkOption {
      type = with types; nullOr enum ["bash"];
      default = "bash";
    };
  };

  config = mkMerge [
    {
      programs.bash.enable = true;
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    }
    /*
      (mkIf cfg.default
      == "alacritty" {
        # programs.hm.alacritty.enable = true;
      }
    )
    */
  ];
}
