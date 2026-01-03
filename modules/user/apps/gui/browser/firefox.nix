{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.firefox;
in
{
	options = {
			userSettings.firefox.enable = lib.mkEnableOption "Enable Firefox";
	};

	config = lib.mkIf cfg.enable {
		programs.firefox = {
			enable = true;
			profiles."defaultProfile" = {
				id = 0;
				isDefault = true;
			};
		};
	};
}
