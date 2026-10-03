{
  description = "Home Manager configuration for Arch Linux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # Change if you want to use another username
      username = "kazuya";
      mkHome = modules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit username;
        };
      };
    in
    {
      # Desktop: home-manager switch --flake .
      homeConfigurations.${username} = mkHome [ ./nix/home.nix ];

      # Home server (Claude Code only): home-manager switch --flake .#server
      homeConfigurations.server = mkHome [ ./nix/common.nix ./nix/claude.nix ];
    };
}
