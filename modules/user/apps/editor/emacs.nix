{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.emacs;
in
{
	options = {
		userSettings.emacs.enable = lib.mkEnableOption "Enable Emacs";
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.emacs.enable = true;
		programs.emacs = {
			enable = true;
		};
	};
}
