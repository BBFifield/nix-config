{lib, ...}: let
  hotloadSubmodule = import ./submodules {inherit lib;};
in {
  imports =
    (lib.concatMap import [./programs])
    ++ [./themes];

  options.hm = {
    enableMutableConfigs = lib.mkEnableOption "Enable configs to be directly modifiable.";
    hotload = lib.mkOption {
      type = (import ./submodules {inherit lib;}).hotload;
    };
    projectPath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Where the project is stored before evaluation. This option is used to update configuration files symlinked from the project to
        wherever they are typically put without having to rebuild the entire configuration.
      '';
    };
  };
}
