{
  config,
  pkgs,
  ...
}: {
  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        shell.program = "${pkgs.bashInteractive}/bin/bash";
      };
    };
  };
}
