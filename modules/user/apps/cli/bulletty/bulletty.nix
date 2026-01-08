{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.bulletty;
in
{
	options = {
		userSettings.bulletty.enable = lib.mkEnableOption "Enable Bulletty RSS reader";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.bulletty
		];
	};
}
