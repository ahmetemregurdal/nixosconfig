{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.swaylock;
	colors = config.lib.stylix.colors;
	font = config.stylix.fonts;
	wallpaper = config.stylix.image;
	swaylockConfig = pkgs.replaceVars ./swaylock.config {
		base01 = colors.base01;
		base05 = colors.base05;
		base08 = colors.base08;
		base0A = colors.base0A;
		base0B = colors.base0B;
		base0D = colors.base0D;
		base0E = colors.base0E;
		fontName = font.monospace.name;
		fontSize = builtins.toString font.sizes.desktop;
		wallpaper = "${wallpaper}";
	};
in
{
	options = {
		userSettings.swaylock.enable = lib.mkEnableOption "Enable Swaylock";
	};

	config = lib.mkIf cfg.enable {
		home.file.".config/swaylock/config".source = swaylockConfig;
		home.packages = [ pkgs.swaylock ];
	};
}
