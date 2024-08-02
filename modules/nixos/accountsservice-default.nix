# Credit goes to github:Cu3P042 for this module which works in conjunction with the declarative-user-icons module to change the gdm user avatar.

{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.accounts-daemon.defaultSettings;

  templateFile = pkgs.writeText "user-template" (generators.toINI {} cfg);
  templateDir = "/share/accountsservice/user-templates";
  templates = pkgs.runCommand "user-templates" {} ''
    mkdir -p $out${templateDir}
    cd $out${templateDir}

    ln -s ${templateFile} administrator
    ln -s ${templateFile} standard
  '';
in {
  options.services.accounts-daemon.defaultSettings = mkOption {
    type = types.anything;
    default = {};
    description = ''
      Settings that should be set on by default on the AccountsService cache
      file for a user.
    '';
  };

  config = {
    environment.systemPackages = [templates];
  };
}
