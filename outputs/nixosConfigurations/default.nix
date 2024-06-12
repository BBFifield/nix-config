{ inputs, outputs, ... }:
with inputs;

let
  hmConfig = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.brandon = import ../../home/home.nix;

        home-manager.sharedModules =
          [ plasma-manager.homeManagerModules.plasma-manager sops-nix.homeManagerModules.sops ];
      };

in {
  virtualbox = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs outputs;
      hostname = "virtualbox";
    };
    modules = [
      ../../systems
      home-manager.nixosModules.home-manager
      hmConfig
    ];
  };
  desktop = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs outputs;
      hostname = "desktop";
    };
    modules = [
      ../../systems
      sops-nix.nixosModules.sops
      home-manager.nixosModules.home-manager
      hmConfig
      "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
      {
        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
      }
    ];
  };

  # Use "sudo nixos-rebuild switch --target-host 192.168.0.30 --flake .#pi2 --use-remote-sudo"
  pi2 = nixpkgs.lib.nixosSystem {
    modules = [
      sops-nix.nixosModules.sops
      ../../systems/pi2/configuration.nix

      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix"
    ];
  };
}
