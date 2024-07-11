{
  inputs,
  ...
}:
with inputs; {
  imports = [
    ../base.nix
    ../desktopEnv.nix
    ./configuration.nix
    ./hardware-configuration.nix
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.users.brandon = import ../../home/home.nix;

      home-manager.sharedModules = [
        plasma-manager.homeManagerModules.plasma-manager
        gBar.homeManagerModules.x86_64-linux.default
        sops-nix.homeManagerModules.sops
      ];
    }
    nixos-generators.nixosModules.all-formats
    {
      formatConfigs.install-iso = {modulesPath, ...}: {
        imports = ["${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"];
      };
    }
  ];
}
