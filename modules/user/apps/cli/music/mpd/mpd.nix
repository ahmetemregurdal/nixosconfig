{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.musicPlayers.mpd;
	rmpcConfig = pkgs.replaceVars ./config.ron {
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
			pkgs.rmpc
		];
		home.file.".config/rmpc/config.ron".source = rmpcConfig;
	};
}
