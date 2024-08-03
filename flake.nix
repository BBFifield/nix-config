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
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument. genAttrs already accepts 'systems' as
    # an argument, but it also needs a function as an argument to execute, which is what will be provide when
    # forAllSystems is called
    forAllSystems = nixpkgs.lib.genAttrs systems;

    hostnames = builtins.attrNames (builtins.readDir ./hosts);
  in rec
  {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = let
      pkgNames = builtins.attrNames (builtins.readDir ./pkgs);
    in
      builtins.listToAttrs (builtins.map (pkgName: {
          name = pkgName;
          value =
            forAllSystems (system:
              nixpkgs.legacyPackages.${system}.callPackage ./pkgs/${pkgName} {});
        })
        pkgNames);

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    # Explanation: Hostnames and nixosSystems are mapped to name and value attributes respectively to create a list of sets,
    # from which attributes of hostname = nixosSystem are created
    nixosConfigurations = builtins.listToAttrs (builtins.map (hostname: {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs hostname;};
          modules = [./hosts/${hostname}/modules-list.nix];
        };
      })
      hostnames);

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
