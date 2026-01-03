{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.beets;
	exportLrc = pkgs.writeShellScript "beetsExportLrc" ''
		set -euo pipefail
		FILE="$1"

		case "$FILE" in
			*.m4a) ;;
			*) exit 0 ;;
		esac

		LRC="''${FILE%.m4a}.lrc"

		[ -f "$LRC" ] && exit 0

		LYRICS="$(${lib.getExe pkgs.exiftool} -s3 -Lyrics "$FILE")" 
		[ -z "$LYRICS" ] && exit 0

		if ! printf '%s\n' "$LYRICS" | grep -Eq '^\[[0-9]{2}:[0-9]{2}\.[0-9]{2}\]'; then
			exit 0
		fi

		printf '%s\n' "$LYRICS" > "$LRC"
		echo "Created LRC: $LRC"
	'';
	beetConfig = pkgs.replaceVars ./beets.config.yaml {
		musicDirectory = config.xdg.userDirs.music;
		xdgDataDir = "${config.home.homeDirectory}/.local/share";
		pathToScript = "${exportLrc}";
	};
in
{
	options = {
		userSettings.beets.enable = lib.mkEnableOption "Enable Beets";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.beets
		];
		home.file.".config/beets/config.yaml".source = beetConfig;
	};
}
