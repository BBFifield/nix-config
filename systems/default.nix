# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, hostname, ... }:

{

  imports = [
    ./${hostname}/configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/St_Johns";

  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  sops.defaultSopsFile = ../secrets/keys.yaml;
  sops.age.keyFile = "/home/brandon/.config/sops/age/keys.txt";

  sops.age.generateKey = true;
  sops.secrets."user_passwords/brandon".neededForUsers = true;
  sops.secrets."user_passwords/root".neededForUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    brandon = {
      hashedPasswordFile = config.sops.secrets."user_passwords/brandon".path;
      isNormalUser = true;
      description = "Brandon";
      extraGroups = [ "networkmanager" "wheel" ];
    };
    root = {
      hashedPasswordFile = config.sops.secrets."user_passwords/root".path;
    };
  };

  environment.variables = {
    EDITOR = "vim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?



  ################# User Additions #########################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  /*programs.bash.shellAliases = {
    "sudo nixos-rebuild switch" = "sudo nixos-rebuild switch --log-format internal-json -v |& nom --json";
    "sudo nixos-rebuild test" = "sudo nixos-rebuild test --log-format internal-json -v |& nom --json";
  };*/
}
