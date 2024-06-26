{ outputs, config, pkgs, lib, ... }:

{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  # Eliminates phantom display 'unknown-1'
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  environment.systemPackages = with pkgs;
    [ nil cachix ssh-to-age age sops htop nix-output-monitor ];

  nixpkgs = {
    overlays = outputs.overlays.defaults;
    config.allowUnfree = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # https://www.reddit.com/r/NixOS/comments/k8yo9e/comment/k13rjna/
  # Avahi is used by the cups daemon to discover ipp printers over a network, no driver for the
  # specific printer is needed
  services.avahi.enable = true;
	services.avahi.nssmdns4 = true;
	services.avahi.openFirewall = true;

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

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    # bluetooth settings
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Enable opengl
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  # This is the beta driver.
  /*hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "555.52.04";
    sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
    sha256_aarch64 = lib.fakeSha256;
    openSha256 = lib.fakeSha256;
    settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
    persistencedSha256 = lib.fakeSha256;
  };*/
}
