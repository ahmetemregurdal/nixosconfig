{
	description = "My overlay";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = {self, nixpkgs}:
		let
			supportedSystems = ["x86_64-linux"];
			forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
			pkgsDir = ./pkgs;
			allPkgs = builtins.readDir pkgsDir;
			validPkgs = nixpkgs.lib.filterAttrs (name: type:
				(type == "directory") || (nixpkgs.lib.hasSuffix ".nix" name && name != "default.nix")) allPkgs;
			makeOverlay = final: prev: nixpkgs.lib.mapAttrs' (name: type:
				let
					cleanName = nixpkgs.lib.removeSuffix ".nix" name;
				in
				nixpkgs.lib.nameValuePair cleanName (final.callPackage (pkgsDir + "/${name}") {})
			) validPkgs;
		in
		{
			overlays.default = makeOverlay;

			packages = forAllSystems (system:
				let
					pkgs = import nixpkgs {inherit system; overlays = [self.overlays.default]; };
				in
				nixpkgs.lib.genAttrs (nixpkgs.lib.mapAttrsToList (n: v: nixpkgs.lib.removeSuffix ".nix" n) validPkgs)
					(name: pkgs.${name})
			);
		};
}
