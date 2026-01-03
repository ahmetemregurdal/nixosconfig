{config, pkgs, lib, inputs, ...}:

let
	cfg = config.userSettings.nixcord;
in
{
	options = {
		userSettings.nixcord = {
			enable = lib.mkEnableOption "Enable NixCord";
		};
	};

	imports = [inputs.nixcord.homeModules.nixcord];

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.nixcord.enable = true;
		programs.nixcord = {
			enable = true;
			discord.enable = true;
			vesktop.enable = true;
		};
	};
}
