{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.helix;
in
{
	options = {
		userSettings.helix = {
			enable = lib.mkEnableOption "Enable Helix";
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.helix.enable = true;
		programs.helix = {
			enable = true;
			settings = {
				editor = {
					line-number = "relative";
				};
			};
		};
	};
}
