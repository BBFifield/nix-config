{ lib, ... }: 
let
  cfg = config.features;
  featuresDir = ../features/nixos;
in
{
  options.features = {
    enabled = {
      type = lib.types List;
      default = [];
      description = "Select which features to enable for the host."
    }
  };
  config = mkIf cfg.enabled != [] {
    imports = lib.concatMap (feature: import ${featuresDir}++feature cfg.enabled);
  };
}