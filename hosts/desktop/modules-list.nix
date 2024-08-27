{
  inputs,
  lib,
  ...
}:
with inputs; {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/nixos/accountsservice-default.nix
    ../../modules/nixos/declarative-user-icons.nix
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
    nixos-generators.nixosModules.all-formats
  ];
}
