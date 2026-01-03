{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.musicPlayers.mpd;
	ncmpcppConf = pkgs.replaceVars ./ncmpcpp_config {

	};
in
{
	options = {
		userSettings.musicPlayers.mpd = {
			enable = lib.mkEnableOption "Enable MPD";
		};
	};

	config = lib.mkIf cfg.enable {
		services.mpd = {
			enable = true;
			extraConfig = builtins.readFile ./mpd.conf;
		};
		home.packages = [
			pkgs.mpc
			pkgs.ncmpcpp
		];
		home.file.".config/ncmpcpp/config".source = ncmpcppConf;
	};
}
