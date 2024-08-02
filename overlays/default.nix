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

  customPkgs = let
    pkgNames = builtins.attrNames (builtins.readDir ../pkgs);
  in
    final: prev:
      builtins.listToAttrs (builtins.map (pkgName: {
          name = pkgName;
          value = prev.callPackage ../pkgs/${pkgName} {};
        })
        pkgNames);

  

  # See https://github.com/NixOS/nixpkgs/issues/310755
  vivaldiFixed = final: prev: {
    vivaldi = prev.vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [prev.kdePackages.wrapQtAppsHook];
    });
  };

  # We use `overrideAttrs` instead of defining a new `mkDerivation` to keep
  # the original package's `output`, `passthru`, and so on.
  # Thanks to user:wenjinnn https://github.com/Aylur/dotfiles/issues/179 for the
  # wlr-randr solution to scale cage correctly at hidpi.
  asztalOverlay = final: prev: let
    asztal = inputs.asztal.packages.x86_64-linux.default;
    name = "asztal";
    ags = inputs.ags.packages.x86_64-linux.default.override {
      extraPackages = [prev.accountsservice];
    };

    dependencies = with prev; [which
    dart-sass
    fd
    fzf
    brightnessctl
    swww
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3]; # not sure why this can be left empty
    addBins = list: builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);
  in
    {asztal = asztal.overrideAttrs (oldAttrs: {
      installPhase = let
        greeter = prev.writeShellScript "greeter" ''
          export PATH=$PATH:${addBins dependencies}
          ${prev.cage}/bin/cage -ds -m last -- ${prev.bash}/bin/bash -c "${prev.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --scale 2 && ${ags}/bin/ags -c ${asztal}/greeter.js"
        '';
        desktop = prev.writeShellScript name ''
          export PATH=$PATH:${addBins dependencies}
          ${ags}/bin/ags -b ${name} -c ${asztal}/config.js $@
        '';
      in 
      ''
        mkdir -p $out/bin
        cp -r . $out
        cp ${greeter} $out/bin/greeter
        cp ${desktop} $out/bin/${name}
      '';
  });};

  defaults = [
    inputs.nurpkgs.overlay
  ];
}
