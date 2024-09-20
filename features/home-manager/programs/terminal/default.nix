{

config,

lib,
  ...
}:
with lib; {
  imports = [
    ./alacritty
    ./starship
  ];

  options.hm.terminal = {
    default = mkOption {
      type = with types; nullOr enum ["alacritty"];
      default = "alacritty";
    };
    shell = mkOption {
      type = with types; nullOr enum ["bash"];
      default = "bash";
    };
  };

  config = {
    programs.bash.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
