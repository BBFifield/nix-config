{inputs, ...}: with inputs;

{
  virtualbox = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs; hostname = "virtualbox";};
    modules = [
      ../../systems
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.brandon = import ../../home/home.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
      }
    ];
  };
  desktop = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs; hostname = "desktop";};
    modules = [
      ../../systems
      sops-nix.nixosModules.sops
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.brandon = import ../../home/home.nix;

        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

        # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
      }
    ];
  };

  # Use "sudo nixos-rebuild switch --target-host 192.168.0.30 --flake .#pi2 --use-remote-sudo"
  pi2 = nixpkgs.lib.nixosSystem {
    modules = [
      sops-nix.nixosModules.sops
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix"
      ../../systems/pi2/configuration.nix
    ];
  };
}
