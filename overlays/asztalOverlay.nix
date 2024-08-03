# We use `overrideAttrs` instead of defining a new `mkDerivation` to keep
# the original package's `output`, `passthru`, and so on.
# Thanks to user:wenjinnn https://github.com/Aylur/dotfiles/issues/179 for the
# wlr-randr solution to scale cage correctly at hidpi.
{inputs, ...}: f: p: let
  asztal = inputs.asztal.packages.x86_64-linux.default;
  name = "asztal";
  ags = inputs.ags.packages.x86_64-linux.default.override {
    extraPackages = [p.accountsservice];
  };

  dependencies = with p; [
    which
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
    gtk3
  ];
  addBins = list: builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);
in {
  asztal = asztal.overrideAttrs (oldAttrs: {
    installPhase = let
      greeter = p.writeShellScript "greeter" ''
        export PATH=$PATH:${addBins dependencies}
        ${p.cage}/bin/cage -ds -m last -- ${p.bash}/bin/bash -c "${p.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --scale 2 && ${ags}/bin/ags -c ${asztal}/greeter.js"
      '';
      desktop = p.writeShellScript name ''
        export PATH=$PATH:${addBins dependencies}
        ${ags}/bin/ags -b ${name} -c ${asztal}/config.js $@
      '';
    in ''
      mkdir -p $out/bin
      cp -r . $out
      cp ${greeter} $out/bin/greeter
      cp ${desktop} $out/bin/${name}
    '';
  });
}
