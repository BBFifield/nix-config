{inputs, ...}: {
  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  uboot = final: prev: {
    ubootRaspberryPi2 = prev.ubootRaspberryPi2.overrideAttrs (oldAttrs: {
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

  defaults = [
    inputs.nurpkgs.overlay
  ];

  # See https://github.com/NixOS/nixpkgs/issues/310755
  vivaldiFixed = final: prev: {
    vivaldi = prev.vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [prev.kdePackages.wrapQtAppsHook];
    });
  };
}
