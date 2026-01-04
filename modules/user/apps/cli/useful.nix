{lib, pkgs, config, ...}:

let
	cfg = config.userSettings.shell.useful;
in
{
	options = {
		userSettings.shell.useful = {
			enable = lib.mkEnableOption "Enable useful terminal packages";
		};
	};

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.yazi.enable = true;
		stylix.targets.btop.enable = true;

		programs.yazi = {
			enable = true;
			enableZshIntegration = true;
		};

		programs.zoxide = {
			enable = true;
			enableZshIntegration = true;
		};

		programs.btop.enable = true;

		home.packages = with pkgs; [
			atool
			p7zip
			unrar
			unzip
			libqalculate
			shntool
			flac
			monkeysAudio
			ffmpeg-full
			apktool
		];
	};
}
