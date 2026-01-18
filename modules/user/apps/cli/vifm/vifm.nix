{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.vifm;
	vifmConfig = pkgs.replaceVars ./vifmrc {
	};
in
{
	options = {
		userSettings.vifm.enable = lib.mkEnableOption "Enable Vifm";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.vifm-full
		];
		home.file.".config/vifm/vifmrc".source = vifmConfig;
		home.file.".config/vifm/colors/Default.vifm".source = ./colorscheme.vifm;
	};
}
