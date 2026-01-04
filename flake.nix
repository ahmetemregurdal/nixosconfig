{
	description = "NixOS config flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		stylix = {
			url = "github:nix-community/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		chaotic = {
			url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
		nixvim = {
			url = "github:nix-community/nixvim";
		};
		nixcord = {
			url = "github:kaylorben/nixcord";
		};
		nix-gaming = {
			url = "github:fufexan/nix-gaming";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		alejandra = {
			url = "github:kamadorueda/alejandra";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nur = {
			url = "github:nix-community/NUR";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{self, nixpkgs, home-manager, niri, chaotic, nur, nix-index-database, ...}:

	let
		lib = inputs.nixpkgs.lib;
		hosts = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (builtins.readDir ./hosts));
	in
	{
		nixosConfigurations = builtins.listToAttrs
		(map (host: {
		name = host;
		value = lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				{ config.networking.hostName = host; }
				home-manager.nixosModules.home-manager
				nur.modules.nixos.default
				chaotic.nixosModules.default
				nix-index-database.nixosModules.nix-index
				{ programs.nix-index-database.comma.enable = true; }
				{
					nixpkgs.overlays = [
						niri.overlays.niri
					];
					home-manager.useGlobalPkgs = true;
					home-manager.extraSpecialArgs = {
						inherit inputs;
						inherit nixpkgs;
					};
				}
				(./hosts + "/${host}/default.nix")
				./modules/system/default.nix
			];
			specialArgs = {
				inherit inputs;
			};
		};
		}) hosts);
	};
}
