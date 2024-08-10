{ pkgs, ... }: 
{
  programs.neovim = {
    enable = true;
  };

  home.packages = with pkgs; [ 
    lunarvim 
    wl-clipboard # For system clipboard capabilities
  ];

  home.file.".config/lvim/init.lua".text = ''
    ${builtins.readFile ./config.lua}
  '';
}
