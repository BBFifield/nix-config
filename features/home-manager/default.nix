{lib, ...}:
with lib; {
  imports =
    (lib.concatMap import [./programs])
    ++ [./themes];

  options.hm = {
    enableMutableConfigs = mkEnableOption "Enable configs to be directly modifiable.";
    projectPath = mkOption {
      type = types.str;
      default = "";
      description = ''
        Where the project is stored before evaluation. This option is used to update configuration files symlinked from the project to
        wherever they are typically put without having to rebuild the entire configuration.
      '';
    };
  };
}
