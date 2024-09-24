{
  config,
  pkgs,
  ...
}: let
  family = "JetBrainsMono Nerd Font";
in {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        import = [pkgs.alacritty-theme.catppuccin_mocha];
        font = {
          size = 11.0;
          bold = {
            inherit family;
            style = "Bold";
          };
          bold_italic = {
            inherit family;
            style = "Bold Italic";
          };
          italic = {
            inherit family;
            style = "Italic";
          };
          normal = {
            inherit family;
            style = "Regular";
          };
        };
        window = {
          opacity = 0.9;
        };
      };
    };
  };
}
