{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.shell.useless;
in
{
	options = {
		userSettings.shell.useless = {
			enable = lib.mkEnableOption "Enable useless shell tools";
		};
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			onefetch
			fastfetch
			figlet
			asciinema
		];
	};
}
