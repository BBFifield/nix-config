{ lib, modulesPath, ... }:

let
  desktopEnv = "none";
in

  assert lib.assertOneOf "desktopEnv" desktopEnv [ "none" ];

{
  imports = [
    (import ../base.nix {inherit desktopEnv;})
    ./configuration.nix
    #sops-nix.nixosModules.sops
    "${modulesPath}/installer/sd-card/sd-image-armv7l-multiplatform.nix"
  ];
}
