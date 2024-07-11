{
  inputs = {
    #devshell = {
    #  url = "github:numtide/devshell";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #elewrap = {
    #  url = "github:oddlama/elewrap";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    #microvm = {
    #  url = "github:astro/microvm.nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nix-index-database = {
    #  url = "github:Mic92/nix-index-database";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nix-topology = {
    #  url = "github:oddlama/nix-topology";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nixos-extra-modules = {
    #  url = "github:oddlama/nixos-extra-modules";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nixos-hardware.url = "github:NixOS/nixos-hardware";

    #nixos-generators = {
    #  url = "github:nix-community/nixos-generators";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nixos-nftables-firewall = {
    #  url = "github:thelegy/nixos-nftables-firewall";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    #nixpkgs-gpu-screen-recorder.url = "github:NixOS/nixpkgs/032e70533b134ea30c0359886dcdec547134dbdd";

    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #pre-commit-hooks = {
    #  url = "github:cachix/pre-commit-hooks.nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

#     sops-nix = {
#       url = "github:Mic92/sops-nix";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };

    #stylix = {
    #  url = "github:danth/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.home-manager.follows = "home-manager";
    #};

    #templates.url = "github:NixOS/templates";
  };

  outputs = {self, nixpkgs, disko, home-manager, /*sops-nix,*/ impermanence, ...}@inputs: {

    nixosConfigurations.wintermute = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [
        ./configuration.nix

        disko.nixosModules.disko

        ./fs.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.users.bloomwhaler = import ./home.nix;
        }

        impermanence.nixosModules.impermanence

#         sops-nix.nixosModules.sops
      ];
    };
     
  };

}

