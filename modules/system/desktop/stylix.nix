{lib, config, pkgs, inputs, ...}:

let 
cfg = config.systemSettings.stylix;
theme = import ( ./. + "../../../themes"+("/"+config.systemSettings.stylix.theme));
in
{
	options = {
		systemSettings.stylix = {
			enable = lib.mkEnableOption "Enable stylix theming";
			theme = lib.mkOption {
				default = "gruvbox-dark-medium";
				type = lib.types.enum (builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../../themes)));
				description  = "Theme to use for stylix";
			};
		};
	};

	imports = [ inputs.stylix.nixosModules.stylix ];

	config = lib.mkIf cfg.enable {
		stylix = {
			enable = true;
			autoEnable = false;
			polarity = theme.polarity;
			image = pkgs.fetchurl {
				url = theme.backgroundUrl;
				sha256 = theme.backgroundSha256;
			};
			base16Scheme = theme;
			fonts = {
				monospace = {
					name = "FiraCode Nerd Font";
					package = pkgs.nerd-fonts.fira-code;
				};
				serif = {
					name = "Fira Sans";
					package = pkgs.fira-sans;
				};
				sansSerif = {
					name = "Fira Sans";
					package = pkgs.fira-sans;
				};
				emoji = {
					name = "Twitter Color Emoji";
					package = pkgs.twitter-color-emoji;
				};
				sizes = {
					terminal = 12;
					applications = 12;
					popups = 12;
					desktop = 12;
				};
			};

			targets.console.enable = true;
			targets.plymouth.enable = true;
			targets.fontconfig.enable = true;
			targets.font-packages.enable = true;
			targets.gtk.enable = true;
			targets.qt.enable = true;

			cursor = {
				package = pkgs.capitaine-cursors;
				name = "capitaine-cursors";
				size = 40;
			};
		};
	};
}
