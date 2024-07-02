# nix-config

Feel free to use parts of this repo as part of your nixos configuration in whatever way you want. 

It's not the most fleshed out config you'll find out there, but in my opinion, it uses practices which will allow it to expand and scale efficiently in the future as new features are introduced.

Currently, there's a primary focus to organize declarations according to system type and desktop environment. Those with a Raspberry Pi 2B might be particularly interested in how one would go about writing such a system config - a custom overlay for uboot is detailed so the system may automatically boot NixOS without keyboard input.
