{
  self,
  lib,
  inputs,
  ...
}: {
  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = f: _p: {
    stable = import inputs.nixpkgs-stable {
      system = f.system;
      config.allowUnfree = true;
    };
  };

  uboot = f: p: {
    ubootRaspberryPi2 = p.ubootRaspberryPi2.overrideAttrs (oldAttrs: {
      extraConfig = ''
        CONFIG_AUTOBOOT=y
        CONFIG_AUTOBOOT_KEYED=y
        CONFIG_AUTOBOOT_STOP_STR="\x0b"
        CONFIG_AUTOBOOT_KEYED_CTRLC=y
        CONFIG_AUTOBOOT_PROMPT="autoboot in 1 second (hold 'CTRL^C' to abort)\n"
        CONFIG_BOOT_RETRY_TIME=15
        CONFIG_RESET_TO_RETRY=y
      '';
    });
  };

  customPkgs = f: p:
    lib.pathToAttrs "${self}/pkgs" (full_path: _: p.callPackage full_path {});

  nonFlakeSrcs = f: p: {
    inherit (inputs) neovim-config;
    inherit (inputs) firefox-gnome-theme;
    inherit (inputs) yazi-flavors;
  };

  # See https://github.com/NixOS/nixpkgs/issues/310755
  vivaldiFixed = f: p: {
    vivaldi = p.vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [p.kdePackages.wrapQtAppsHook];
    });
  };

  asztalOverlay = import ./asztalOverlay.nix {inherit inputs;};

  defaults = [
    inputs.nurpkgs.overlay
    inputs.hyprpanel.overlay
    inputs.alacritty-theme.overlays.default
  ];
}
