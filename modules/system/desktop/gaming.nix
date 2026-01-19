{lib, config, pkgs, inputs, ...}:

let
	cfg = config.systemSettings.gaming;
in
{
	options = {
		systemSettings.gaming = {
			enable = lib.mkEnableOption "Enable gaming packages";
		};
	};

	imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

	config = lib.mkIf cfg.enable {
		programs.gamemode = {
			enable = true;
		};
		programs.gamescope = {
			enable = true;
		};
		programs.steam = {
			enable = true;
			extraCompatPackages = with pkgs; [
				proton-ge-bin
			];
			platformOptimizations.enable = true;
		};

		users.groups = {
			steam = {
				members = config.systemSettings.users;
			};
		};
	};
}
