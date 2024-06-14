# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ outputs, lib, hostname, config, pkgs, ... }:

{

  # Define your hostname.
  networking.hostName = hostname;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable the KDE Plasma 6 Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
  };

  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    nil
    nix-output-monitor ] ++
    ( with kdePackages; [
    sddm-kcm
    partitionmanager
    kpmcore
    kde-cli-tools
  ]);

  nixpkgs = {
    overlays = outputs.overlays.defaults;
    config.allowUnfree = true;
  };

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.clipboard = true;

}
