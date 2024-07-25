{
  outputs,
  config,
  pkgs,
  lib,
  ...
}: let
  featuresDir = ../../features/nixos;

  features = [
    "base"
    "cups"
    "nvidia"
    "sddm"
    "home-manager"
    "desktop"
  ];

  imports = builtins.map (feature: featuresDir + ("/" + feature + ".nix")) features;
in {
  inherit imports;

  desktop = {
    enable = true;
    session = "hyprland";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = ["armv7l-linux"];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    nil
    cachix
    ssh-to-age
    age
    sops
    htop
    nix-output-monitor
  ];

  nixpkgs = {
    overlays =
      outputs.overlays.defaults
      ++ (with outputs.overlays; [
        vivaldiFixed
        customPkgs
      ]);
    config.allowUnfree = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)i
    #media-session.enable = true;
  };

  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "brandon" ];

  hardware = {
    # bluetooth settings
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}