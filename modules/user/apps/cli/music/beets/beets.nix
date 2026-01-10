{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.beets;
	beetConfig = pkgs.replaceVars ./beets.config.yaml {
		musicDirectory = config.xdg.userDirs.music;
		xdgDataDir = "${config.home.homeDirectory}/.local/share";
	};
	exportLrc = pkgs.writeShellScriptBin "exportLrc" (builtins.readFile ./exportLrc.sh);
	flacToM4a = pkgs.writeShellScriptBin "flac2m4a" (builtins.readFile ./convert.sh);
in
{
	options = {
		userSettings.beets.enable = lib.mkEnableOption "Enable Beets";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.beets
			pkgs.exiftool
			pkgs.parallel-full
			pkgs.shntool
			pkgs.flac
			pkgs.monkeysAudio
			pkgs.ffmpeg-full
			exportLrc
			flacToM4a
		];
		home.file.".config/beets/config.yaml".source = beetConfig;
	};
}
