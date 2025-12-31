{config, lib, pkgs, ...}:

let
	cfg = config.userSettings.fuzzel;
	font = config.stylix.fonts;
	colors = config.lib.stylix.colors;
	spawnTerm = config.userSettings.spawnTerminal;
	fuzzelIni = pkgs.replaceVars ./fuzzel.ini {
		fontName = font.monospace.name;
		fontsize = toString font.sizes.terminal;
		spawnTerm = spawnTerm;
		base00 = colors.base00;
		base05 = colors.base05;
		base09 = colors.base09;
		base0A = colors.base0A;
		base0D = colors.base0D;
		base0E = colors.base0E;
	};
in
{
	options = {
		userSettings.fuzzel = {
			enable = lib.mkEnableOption "Enable Fuzzel";
		};
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.fuzzel
		];
		home.file.".config/fuzzel/fuzzel.ini".source = fuzzelIni;
	};
}
