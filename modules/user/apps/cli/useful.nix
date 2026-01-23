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
		stylix.targets.btop.enable = true;

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
			syncthing
			apktool
			gcc
			man-pages
			man-pages-posix
			compiledb
			gnumake
		];
	};
}
