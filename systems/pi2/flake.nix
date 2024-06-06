{
  description = "Build Raspberry Pi 2 sd image";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    deploy-rs =  {
      url = "github:serokell/deploy-rs";
    };
  };


  outputs = { self, nixpkgs, deploy-rs }:
    let
      /*system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlay (final: prev: {
          deploy-rs = { inherit (pkgs) deploy-rs; lib = prev.deploy-rs.lib; }; } )
        ];
      };*/
    in
    rec {
    nixosConfigurations.pi2 =
      nixpkgs.legacyPackages.x86_64-linux.pkgsCross.armv7l-hf-multiplatform.nixos {

        imports = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix"
          nixosModules.pi2
        ];
      };

    nixosModules.pi2 = ({ lib, config, pkgs, modulesPath, ... }: {

      users.users = {
        brandon = {
          isNormalUser = true;
          description = "Brandon";
          password = "default";
          extraGroups = [ "networkmanager" "wheel" ];
          #packages = with pkgs; [
          #  thunderbird
          #];
        };
        root = {
          password = "default";
        };
      };

      environment.systemPackages = with pkgs; [
        neofetch
        vim
        nix-output-monitor
      ];

      services.openssh = {
        enable = lib.mkDefault true;
        settings.PermitRootLogin = "yes";
        #settings.PasswordAuthentication = false;
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed255119 AAAAC3NzaC1lZDI1NTE5AAAAIMbUPOHQI/iLB6tSyR9Jh9OVJuPkNUNqBlQBgEwiyXYr bb.fifield@gmail.com"
      ];

      networking.hostName = "pi2";

      # needed for deploy-rs
      boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

      # good luck
      # needed for the stlink to work
      #boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi2;

      # if you don't have this and you have 2 network devices plugged in
      # with the rpi kernel then networking breaks due to kernel bugs. lol.
      #boot.kernelParams = [ "coherent_pool=4M" ];

      disabledModules = [
        "${modulesPath}/profiles/all-hardware.nix"
        "${modulesPath}/profiles/base.nix"
      ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      system.stateVersion = "24.11";
    });


    deploy.nodes.pi2 = {
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.pi2;
      };

      # this is how it ssh's into the target system to send packages/configs over.
      sshUser = "root";
      hostname = "pi2";
    };

    images.pi2 = nixosConfigurations.pi2.config.system.build.sdImage;
  };
}






