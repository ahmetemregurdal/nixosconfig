{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.musicPlayers.mpd;
	rmpcConfig = pkgs.replaceVars ./config.ron {
		musicDir = config.xdg.userDirs.music;
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
			pkgs.rmpc
			pkgs.cava
		];
		home.file.".config/rmpc/config.ron".source = rmpcConfig;
		home.file.".config/rmpc/themes/defaultTheme.ron".source = ./defaultTheme.ron;
	};
}
