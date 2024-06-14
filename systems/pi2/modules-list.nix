{inputs, modulesPath, ...}:

{
  modules = with inputs; [
    ../base.nix
    ./configuration.nix
    ./hardware-configuration.nix
    sops-nix.nixosModules.sops

    "${modulesPath}/installer/sd-card/sd-image-armv7l-multiplatform.nix"
  ];
}
