# nix-config

Feel free to use parts of this repo as part of your nixos configuration in whatever way you want. 

Currently, there's a primary focus to organize declarations according to host and desktop environment.

## Outputs:

There are several outputs provided by this flake. If you want to utilize any of them inside your flake, just follow the instructions below.

The first step is to add this repository to inputs inside your flake. 

```nix 
inputs.<my-repo> = {
  url = "github:/BBFifield/nix-config";
};
```

### Packages:

The packages supplied by this flake are found in the _pkgs_ directory. These may be pushed upstream at some point, but there is no guarantee. On the other hand, if I discover any of the packages are now hosted in Nixpkgs, they will be removed for convenience purposes.

Call any of my custom packages with;

`<name> = inputs.<my-repo>.packages.<system>.<package_name>;`

Example: `klassy = inputs.<my-repo>.packages.x86_64-linux.klassy;` Then you can add it to your environment.packages or home.packages.

### Raspberry Pi 2B:

**Note: The Raspberry Pi config is currently outdated and some adjustments need to be made to get it working with this flake again, which I plan to do over the next little while.**

Those with a Raspberry Pi 2B might be particularly interested in how one would go about writing such a system config - a custom overlay for uboot is detailed so the system may automatically boot NixOS without keyboard input.

#### Building the SD image through this flake:
You may build your own Raspberry Pi image with `nix build /path/to/flake#images.pi2`. Then you may write the image to the root of your
SD card with `zstdcat <path/to/sd-image> | sudo dd of=<device> bs=4M status=progress oflag=direct iflag=fullblock`.
