# Use command "fc-list : family style" to see a list of fonts on your system.
{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["JetBrainsMono Nerd Font"]; #["FiraCode Nerd Font"];
  };

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["VictorMono" "IosevkaTerm" "JetBrainsMono" "Iosevka" "RobotoMono" "CascadiaCode"]; #["Iosevka" "FiraCode" "RobotoMono" "JetBrainsMono" "CascadiaCode"];
    })
    iosevka
  ];
}
