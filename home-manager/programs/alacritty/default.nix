{
  config,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [alacritty-theme];
    programs.alacritty = {
      enable = true;
      settings = {
       # shell.program = "${pkgs.bashInteractive}/bin/bash";
        #import = [ "~/.config/alacritty/themes/themes/catpuccin_mocha.toml" ];
        /* Fonts were specified because FiraCode isn't compatible with alacritty yet */
        font = {
          size= 11.0;
          bold = {
            family = "RobotoMono Nerd Font";
            style = "Bold";
          };
          bold_italic = {
            family = "RobotoMono Nerd Font";
            style = "Bold Italic";
          };
          italic = {
            family = "RobotoMono Nerd Font";
            style = "Italic";
          };
          normal = {
            family = "RobotoMono Nerd Font";
            style = "Regular";
          };
        };
      };
    };
  };
}
