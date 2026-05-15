{
  description = "dotfiles managed by Nix + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      mkHome = { system, username, homeDirectory, isWSL ? false }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          extraSpecialArgs = { inherit isWSL; };
          modules = [
            ./nix/home/common.nix
            ./nix/home/linux.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };
    in {
      homeConfigurations = {
        "ubuntu" = mkHome {
          system = "x86_64-linux";
          username = "${builtins.getEnv "USER"}";
          homeDirectory = "${builtins.getEnv "HOME"}";
          isWSL = true;
        };

        "arch" = mkHome {
          system = "x86_64-linux";
          username = "${builtins.getEnv "USER"}";
          homeDirectory = "${builtins.getEnv "HOME"}";
        };
      };
    };
}
