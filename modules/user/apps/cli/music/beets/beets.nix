{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.beets;
	beetConfig = pkgs.replaceVars ./beets.config.yaml {
		musicDirectory = config.xdg.userDirs.music;
		xdgDataDir = "${config.home.homeDirectory}/.local/share";
	};
	exportLrc = pkgs.writeShellScriptBin "exportLrc" (builtins.readFile ./exportLrc.sh);
in
{
	options = {
		userSettings.beets.enable = lib.mkEnableOption "Enable Beets";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.beets
			pkgs.exiftool
			exportLrc
		];
		home.file.".config/beets/config.yaml".source = beetConfig;
	};
}
