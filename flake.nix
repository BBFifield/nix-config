{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

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

    nurpkgs.url = "github:nix-community/NUR";
  };

  outputs = { self,
              nixpkgs,
              home-manager,
              plasma-manager, ... }@inputs:

    let
      /*initPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [nurpkgs.overlay];
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;

      };*/
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
    in
  {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      virtualbox = nixpkgs.lib.nixosSystem {
        #pkgs = initPkgs "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./systems/virtualbox/configuration.nix
>>>>>>> 9938512 (Added plasma-manager)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.brandon = import ./home/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        #pkgs = initPkgs "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./systems/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.brandon = import ./home/home.nix;

            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
