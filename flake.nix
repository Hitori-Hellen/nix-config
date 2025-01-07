{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    swww.url = "github:LGFae/swww";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    swww,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    inherit (self) outputs;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem rec {
        specialArgs = {inherit inputs outputs;};

        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix nixos-hardware.nixosModules.asus-zephyrus-ga401];
      };
    };
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [./home.nix];
      extraSpecialArgs = {inherit inputs outputs;};
    };
  };
}
