# This file is based on the following comment by jonathan-conder:
# https://github.com/NixOS/nixpkgs/issues/163080#issuecomment-1722465663
# The original comment has the limitation that updates to icons would not
# necessarily be picked up. This should be rectified by user github:Cu3PO42's version.
{
  config,
  lib,
  pkgs,
  ...
}: let
  userIconsPath = "/etc/user-icons";

  usersWithIcons = lib.filterAttrs (_: value: value.icon != null) config.users.users;
  # First covers the sddm use-case, and the second is for asztal greetd.
  iconLinks = lib.mapAttrsToList (name: value: "ln -s ${value.icon} ${name}.face.icon") usersWithIcons;
  iconLinks2 = lib.mapAttrsToList (name: value: "ln -s ${value.icon} ${name}") usersWithIcons;
  icons = pkgs.runCommand "user-icons" {} ''
    mkdir -p $out${userIconsPath}
    cd $out${userIconsPath}
    ${lib.concatStringsSep "\n" iconLinks}
    ${lib.concatStringsSep "\n" iconLinks2}
  '';
in {
  options.users.users = with lib;
    mkOption {
      type = types.attrsOf (types.submodule {
        options.icon = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            An icon to use for the user in their login manager and other UIs.
          '';
        };
      });
    };

  config = {
    services.accounts-daemon.defaultSettings.User.Icon = "/run/current-system/sw${userIconsPath}/\${USER}";

    environment.pathsToLink = [userIconsPath];

    environment.systemPackages = [icons];

    system.activationScripts = {
      user_Icons = {
        text = ''
          cp -rf /run/current-system/sw${userIconsPath}/* /var/lib/AccountsService/icons/
        '';
      };
    };
  };
}
