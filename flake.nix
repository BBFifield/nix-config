{

  nixConfig = {
    extra-substitutors = [ "https://app.cachix.org/cache/bbfifield" ];

    extra-trusted-public-keys =
      [ "bbfifield.cachix.org-1:CCnFT1vusYyocjxJNHQKnighiTQSnv/LquQcZ3xrTgg=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      hostnames = builtins.attrNames (builtins.readDir ./systems);
    in rec {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      # packages = forAllSystems (system: nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = builtins.listToAttrs (builtins.map (hostname: {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs hostname; };
          modules = [./systems/${hostname}/modules-list.nix];
        };
      }) hostnames);

      # nix build .#images.pi2
      images.pi2 = nixosConfigurations.pi2.config.system.build.sdImage;

      # nix build .#images.desktop
      images.desktop = nixosConfigurations.desktop.config.formats.install-iso;
    };
}
