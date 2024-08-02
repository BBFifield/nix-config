{
  config,
  lib,
  ...
}: {
  options.hm.gBar = {
    enable = lib.mkEnableOption "Enable gBar";
  };

  config = lib.mkIf config.hm.gBar.enable {
    programs.gBar = {
      enable = true;
      config = {
        Location = "T";
        EnableSNI = true;
        SNIIconSize = {
          Discord = 26;
          OBS = 23;
        };
        #WorkspaceSymbols = [ " " " " ];
        AudioRevealer = true;
        NetworkAdapter = "enp9s0";
        #0b:00.0 is gpu pci address
      };
      extraCSS = ''
        ${builtins.readFile ./style.css}
      '';
    };
  };
}
