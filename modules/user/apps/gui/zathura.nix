{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.zathura;
in
{
	options = {
		userSettings.zathura.enable = lib.mkEnableOption "Enable Zathura";
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.zathura.enable = true;
		programs.zathura = {
			enable = true;
			options = {
				recolor = true;
				font = config.stylix.fonts.monospace.name + " 12";
				database = "sqlite";
				incremental-search = true;
			};
		};
	};
}
