{ lib, config, pkgs, outputs, modulesPath, ... }:


{
  # With regard to the substitutors
  nix.settings.trusted-users = [ "brandon" ];

  networking.networkmanager.enable = lib.mkForce false;

  /*sops.defaultSopsFile = ../../secrets/keys.yaml;
  sops.age.keyFile = "../../secrets/private/keys.txt";
  sops.age.generateKey = true;

  sops.secrets."user_passwords/brandon".neededForUsers = true;
  sops.secrets."user_passwords/root".neededForUsers = true;*/

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed255119 AAAAC3NzaC1lZDI1NTE5AAAAIMbUPOHQI/iLB6tSyR9Jh9OVJuPkNUNqBlQBgEwiyXYr bb.fifield@gmail.com"
      ];
    };
  };

 /* networking = {
    hostName = "pi2";
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };*/

  nixpkgs = {
    overlays = [ outputs.overlays.uboot ];
    config.platform = lib.systems.platforms.raspberrypi2;
    config.allowUnsupportedSystem = true;
    hostPlatform.system = "armv7l-linux";
    buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
  };

  environment.systemPackages = with pkgs; [
    arduino-cli
  ];


  boot = {
    supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
    # only add strictly necessary modules
    initrd.includeDefaultModules = false;
    initrd.kernelModules = [ "ext4" "mmc_block" ];

    # Needed for deploy.rs to work
    binfmt.emulatedSystems = [ "x86_64-linux" ];


    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi2;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = true;
      generationsDir.enable = lib.mkDefault false;
    };
  };

  disabledModules = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  powerManagement.enable = lib.mkDefault false;

  services.openssh.settings.PermitRootLogin = "yes";

/*
  */

/*
  hardware.deviceTree = {
    enable = true;
    overlays = [
      {
        name = "enable-i2c1-device";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          / { compatible = "brcm,bcm2835"; };
          &i2c1 { status = "okay"; };
        '';
      }
    ];
  };
  hardware.i2c.enable = true;
*/
  #hardware.enableRedistributableFirmware = true;
  #hardware.firmware = [ pkgs.firmwareLinuxNonfree ];

  documentation.doc.enable = false;
  documentation.man.enable = false;

  system.stateVersion = "24.11";

}
