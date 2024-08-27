{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.nixos.desktop;
in {
  imports = [
    ./session.nix
    ./display-manager.nix
    ./nautilus.nix
  ];

  config = lib.mkMerge [
   /* { 
      systemd.globalEnvironment = { GDK_SCALE = "2"; }; 
    }*/ 
    (lib.mkIf (cfg.plasma.enable && !cfg.gnome.enable) {
      warnings =
        if cfg.displayManager != "sddm"
        then [
          ''            You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to
                                "sddm" when "plasma" is enabled.
          ''
        ]
        else [];
      services.displayManager.sddm = lib.mkForce {
        wayland.compositor = "kwin";
        theme = "breeze";
      };
    })

    (lib.mkIf (cfg.gnome.enable) {
      warnings =
        if cfg.displayManager != "gdm"
        then [
          ''            You have set the display-manager to ${cfg.displayManager}. It is recommended to set it to
                                "gdm" when "gnome" is enabled, otherwise problems with the lockscreen may occur.
          ''
        ]
        else [];
    })

    (lib.mkIf (cfg.hyprland.enable) (
      {
        assertions = [
          {
            assertion = config.displayManager == "gdm";
            message = "You have set the display-manager to ${cfg.displayManager}. GDM may cause hyprland to crash on first launch.";
          }
        ];
      }
      // lib.mkMerge [
        (lib.mkIf (cfg.displayManager == "sddm") {
          services.displayManager.sddm = {
            wayland.compositor = "weston";
            theme = "catppuccin-frappe";
          };

          environment.systemPackages = [(
            pkgs.catppuccin-sddm.override {
              flavor = "frappe";
              font  = "Fira Code";
              fontSize = "11";
            }
          )];
          fonts.packages = with pkgs; [
            fira-code
          ];
        })
        (lib.mkIf (cfg.hyprland.shell == "asztal" && cfg.displayManager == "greetd") {
          services.greetd = {
            settings.default_session.command = lib.mkForce pkgs.writeShellScript "greeter" ''
              export WLR_NO_HARDWARE_CURSORS=1
              export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
              export XCURSOR_THEME=BreezeX-Dark
              export XCURSOR_SIZE=28
              ${pkgs.asztal}/bin/greeter
            '';
          };

          systemd.tmpfiles.rules = [
            "d '/var/cache/greeter' - greeter greeter - -"
          ];

          system.activationScripts.wallpaper = let
            wp = pkgs.writeShellScript "wp" ''
              CACHE="/var/cache/greeter"
              OPTS="$CACHE/options.json"
              HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"

              mkdir -p "$CACHE"
              chown greeter:greeter $CACHE

              if [[ -f "$HOME/.cache/ags/options.json" ]]; then
                cp $HOME/.cache/ags/options.json $OPTS
                chown greeter:greeter $OPTS
              fi

              if [[ -f "$HOME/.config/background" ]]; then
                cp "$HOME/.config/background" $CACHE/background
                chown greeter:greeter "$CACHE/background"
              fi
            '';
          in
            builtins.readFile wp;
        })
      ]
    ))
  ];
}
