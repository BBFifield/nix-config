{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0";

    asztal = {
      url = "github:Aylur/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ags.follows = "ags";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # Maps a function over the 'systems' attribute set. 'Systems' is provided as the first arg, but it also
    # needs a function as the second arg, which is provided below when forAllSystems is called.
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in rec
  {
    # My custom libraries
    lib = import ./lib {};

    # My custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # Ex: nix shell packages.x86_64-linux.klassy
    packages = forAllSystems (system:
      lib.pathToAttrs "${self}/pkgs" (full_path: _:
        nixpkgs.legacyPackages.${system}.callPackage "${full_path}" {}));

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit self outputs inputs;};

    nixosConfigurations = lib.pathToAttrs "${self}/hosts" (full_path: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs outputs hostname;};
        modules = ["${full_path}/modules-list.nix"];
      });

    images = {
      # nix build .#images.pi2
      pi2 = nixosConfigurations.pi2.config.system.build.sdImage;
      # nix build .#images.desktop
      desktop = nixosConfigurations.desktop.config.formats.install-iso;
    };
  };

  nixConfig = {
    extra-substitutors = ["https://app.cachix.org/cache/bbfifield"];
    extra-trusted-public-keys = ["bbfifield.cachix.org-1:CCnFT1vusYyocjxJNHQKnighiTQSnv/LquQcZ3xrTgg="];
  };
}
