{ inputs, modulesPath, ... }:
with inputs;

{
  imports = [
    ../base.nix
    ./configuration.nix
    #sops-nix.nixosModules.sops
    "${modulesPath}/installer/sd-card/sd-image-armv7l-multiplatform.nix"
  ];
}
