{modulesPath, ...}: {
  formatConfigs.install-iso = {modulesPath, ...}: {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"];
  };
}
