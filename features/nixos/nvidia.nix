{
  config,
  pkgs,
  lib,
  ...
}: {
  # For vaapi support in firefox
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    GBM_BACKEND = "nvidia-drm";
    _GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_DRM_NO_ATOMIC = "1";
  };

  # Eliminates phantom display 'unknown-1'
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
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
      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  environment.systemPackages = with pkgs; [nvidia-vaapi-driver];
}
