{ pkgs, ... }:
{
  services.xserver.enable = true;

  # Enable the KDE Plasma 6 Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    sddm-kcm
    partitionmanager
    kpmcore
    kde-cli-tools
    kdbusaddons
    isoimagewriter
  ];
}
