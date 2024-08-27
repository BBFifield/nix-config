# Use command "fc-list : family style" to see a list of fonts on your system.
{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["FiraCode Nerd Font"];
  };

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["FiraCode" "RobotoMono" "JetBrainsMono" "CascadiaCode"];
    })
  ];
}
