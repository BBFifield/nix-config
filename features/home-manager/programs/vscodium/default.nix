{
  config,
  pkgs,
  lib,
  ...
}: {
  options.hm.vscodium = {
    enable = lib.mkEnableOption "Enable VSCodium";
    theme = lib.mkOption {
      type = lib.types.enum ["gnome" null];
      default = null;
    };
  };
  config = lib.mkIf config.hm.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
        ]
        ++ lib.optionals (config.hm.vscodium.theme == "gnome") [
          piousdeer.adwaita-theme
        ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "diagnostics" = {
              "ignored" = ["unused_binding" "unused_with"];
            };
            "formatting" = {
              "command" = ["nix fmt"];
            };
          };
        };
        "nix.formatterPath" = ["nix" "fmt" "--" "-"];
        "workbench.colorTheme" = "Adwaita Dark & default syntax highlighting";
      };
    };
  };
}
