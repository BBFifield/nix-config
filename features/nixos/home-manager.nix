{
  self,
  inputs,
  lib,
  ...
}:
with inputs; {
  options.nixos.hm = {
  };

  config = {
    # home-manager.lib = home-manager.lib.extend (f: p: import ../../lib);
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";

    home-manager.users = lib.pathToAttrs "${self}/users" (full_path: _: import full_path);

    # These modules are imported into all home-manager configs
    home-manager.sharedModules = [
      plasma-manager.homeManagerModules.plasma-manager
      gBar.homeManagerModules.x86_64-linux.default
      ags.homeManagerModules.default
      sops-nix.homeManagerModules.sops
      walker.homeManagerModules.default
      ironbar.homeManagerModules.default
    ];
  };
}
