{
  config,
  lib,
  ...
}: let
  cfg = config.features;
  featuresDir = ../features/nixos;
in {
  options.features = {
    enabled = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = "Select which features to enable for the host.";
    };
  };
  config = lib.mkIf (cfg.enabled != []) {
    imports = lib.concatMap (feature: (import featuresDir + feature) cfg.enabled);
  };
}
