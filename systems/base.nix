# The core module of NixOS configuration.

{ pkgs, inputs, hostname, lib, ... }:

{
  # Which desktop environment to use
  /*imports = [
    ./environments/${desktopEnv}.nix
  ];*/

  desktopEnv.enable = "plasma";

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

  # With regard to substitutors
  nix.settings.trusted-users = [ "brandon" ];

  # Enable networking
  networking.networkmanager.enable = lib.mkDefault true;

  networking.hostName = hostname;

  # Set your time zone.
  time.timeZone = "America/St_Johns";

  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  /*
  sops.defaultSopsFile = ../secrets/keys.yaml;
  sops.age.keyFile = "../secrets/private/keys.txt";

  sops.age.generateKey = true;
  sops.secrets."user_passwords/brandon".neededForUsers = true;
  sops.secrets."user_passwords/root".neededForUsers = true;
  */
  users.users = {
    brandon = {
      hashedPassword = "$y$j9T$v4UN6562YZBZR.cqnWOiV0$JhBpDsBHHNtcbjzJ1AeY1JRmtNwwK4QGEAizjey1g6/";
      isNormalUser = true;
      description = "Brandon";
      extraGroups = [ "networkmanager" "wheel" "dialout" ];
    };
    root = {
      hashedPassword = "$y$j9T$2Y/Apsh35UhYHOXBwomYS.$w3PBuxNSv9mIn9/vepOT86hjpl7SaRYGIS04.Z5DGhD";
    };
  };



  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
  ];

  environment.variables = { EDITOR = "vim"; };

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
