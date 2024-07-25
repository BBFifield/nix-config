{inputs, ...}: with inputs; let
  userList = builtins.attrNames (builtins.readDir ../../users);
in {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users = builtins.listToAttrs (builtins.map (user: {
      name = user;
      value = import ../../users/${user};
    })
    userList);

  # These modules are imported into all home-manager configs
  home-manager.sharedModules = [
    plasma-manager.homeManagerModules.plasma-manager
    gBar.homeManagerModules.x86_64-linux.default
    ags.homeManagerModules.default
    sops-nix.homeManagerModules.sops
  ];
}
