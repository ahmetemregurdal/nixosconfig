{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.beets;
in
{
	options = {
		userSettings.beets.enable = lib.mkEnableOption "Enable Beets";
	};

	config = lib.mkIf cfg.enable {
		programs.beets = {
			enable = true;
			settings = {
				directory = config.xdg.userDirs.music;
				library = "${config.home.homeDirectory}/.local/share/beets.dp";
				import = {
					move = true;
				};
				plugins = [
					"musicbrainz"
					"lyrics"
					"fetchart"
					"embedart"
					"fromfilename"
					"convert"
					"replaygain"
				];
				lyrics = {
					synced = true;
				};
				convert = {
					auto = true;
					delete_originals = true;
					format = "AAC";
					never_convert_lossy_files = true;
					formats = {
						aac = {
							command = "ffmpeg -i $source -vn -c:a aac -q:a 6 $dest";
							extension = "m4a";
						};
					};
				};
				replaygain = {
					auto = true;
					backend = "ffmpeg";
					overwrite = true;
					r128 = "flac m4a";
					peak = "true";
				};
			};
		};
	};
}
