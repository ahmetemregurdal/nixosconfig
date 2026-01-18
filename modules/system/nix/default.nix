{config, pkgs, ...}:

{
	config = {
		nix = {
			package = pkgs.nix;
			settings = {
				substituters = [
					"https://cache.nixos.org"
					"https://nix-community.cachix.org"
					"https://chaotic-nyx.cachix.org"
					"https://nix-gaming.cachix.org"
				];
				trusted-public-keys = [
					"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
					"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
					"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
					"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
				];
				auto-optimise-store = true;
				download-buffer-size = 500000000;
			};
		};
		programs.nh = {
			enable = true;
		};
	};
}
