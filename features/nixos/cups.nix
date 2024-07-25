{...}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # https://www.reddit.com/r/NixOS/comments/k8yo9e/comment/k13rjna/
  # Avahi is used by the cups daemon to discover ipp printers over a network, no driver for the
  # specific printer is needed
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
}
