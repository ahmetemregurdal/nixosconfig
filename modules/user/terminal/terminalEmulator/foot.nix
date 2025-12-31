{config, pkgs, lib, ...}: 

let
	cfg = config.userSettings.foot;
in
{
	options = {
		userSettings.foot = {
			enable = lib.mkEnableOption "Enable foot";
		};
	};

	config = lib.mkIf cfg.enable {
		programs.foot.enable = true;
		userSettings.stylix.enable = true;
		stylix.targets.foot.enable = true;
	};
}
