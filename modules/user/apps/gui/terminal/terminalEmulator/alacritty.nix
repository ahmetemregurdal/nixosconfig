{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.alacritty;
in
{
	options = {
		userSettings.alacritty = {
			enable = lib.mkEnableOption "Enable alacritty";
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.alacritty.enable = true;
		programs.alacritty = {
			enable =  true;
		};
	};
}
